import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/practice_repository.dart';
import '../../../data/services/audio_player_service.dart';
import '../../../data/services/audio_recorder_service.dart';
import '../../../domain/models/accent_type.dart';
import '../../../domain/models/assignment.dart';
import '../../../domain/models/speech_evaluation.dart';
import '../../../domain/models/task_item.dart';

class PracticeViewModel extends ChangeNotifier {
  final Assignment assignment;
  final PracticeRepository _practiceRepository;
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final AudioRecorderService _audioRecorderService = AudioRecorderService();

  int _currentIndex = 0;
  AccentType _selectedAccent = AccentType.british;
  double _shadowingDelay = 0.5; // 影子跟读默认延迟 0.5 秒
  bool _isEvaluating = false;
  SpeechEvaluation? _currentEvaluation;

  // 波形数据
  final List<double> _referenceWave = [];
  final List<double> _studentWave = [];
  StreamSubscription? _amplitudeSub;
  StreamSubscription? _playerSub;
  double _playbackProgress = 0.0;

  PracticeViewModel({
    required this.assignment,
    required PracticeRepository practiceRepository,
  }) : _practiceRepository = practiceRepository {
    _init();
  }

  int get currentIndex => _currentIndex;
  TaskItem get currentItem => assignment.items[_currentIndex];
  int get totalItems => assignment.items.length;
  AccentType get selectedAccent => _selectedAccent;
  double get shadowingDelay => _shadowingDelay;
  bool get isEvaluating => _isEvaluating;
  SpeechEvaluation? get currentEvaluation => _currentEvaluation;

  AudioPlayerService get playerService => _audioPlayerService;
  AudioRecorderService get recorderService => _audioRecorderService;
  List<double> get referenceWave => _referenceWave;
  List<double> get studentWave => _studentWave;
  double get playbackProgress => _playbackProgress;

  bool get isPlaying => _audioPlayerService.player.playing;
  bool get isRecording => _audioRecorderService.status == RecordingStatus.recording;
  bool get hasRecordedAudio => _audioRecorderService.currentRecordingPath != null;

  void _init() {
    _selectedAccent = assignment.accentMode == AccentType.american ? AccentType.american : AccentType.british;
    _loadCurrentItemAudio();

    // 监听播放器进度计算百分比
    _playerSub = _audioPlayerService.positionStream.listen((pos) {
      final total = _audioPlayerService.player.duration;
      if (total != null && total.inMilliseconds > 0) {
        _playbackProgress = (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
        notifyListeners();
      }
    });

    // 监听实时录音振幅
    _amplitudeSub = _audioRecorderService.amplitudeStream.listen((amp) {
      _studentWave.add(amp);
      if (_studentWave.length > 50) {
        _studentWave.removeAt(0);
      }
      notifyListeners();
    });
  }

  Future<void> _loadCurrentItemAudio() async {
    _generateMockReferenceWave();
    await _audioPlayerService.setAudioSources(
      britishUrl: currentItem.britishAudioUrl,
      americanUrl: currentItem.americanAudioUrl,
      initialAccent: _selectedAccent,
    );
    notifyListeners();
  }

  void _generateMockReferenceWave() {
    _referenceWave.clear();
    // 模拟标准原声的起伏波形
    final pattern = [0.2, 0.4, 0.7, 0.9, 0.6, 0.3, 0.5, 0.8, 0.7, 0.4, 0.2, 0.6, 0.8, 0.5, 0.2];
    for (int i = 0; i < 45; i++) {
      _referenceWave.add(pattern[i % pattern.length]);
    }
  }

  /// 一键切换英音 (RP) / 美音 (GA)
  Future<void> switchAccent(AccentType accent) async {
    _selectedAccent = accent;
    await _audioPlayerService.switchAccent(accent);
    notifyListeners();
  }

  /// 调整播放语速 (0.8x / 1.0x / 1.2x)
  Future<void> cyclePlaybackSpeed() async {
    final speeds = [0.8, 1.0, 1.2];
    final current = _audioPlayerService.playbackSpeed;
    final nextIndex = (speeds.indexOf(current) + 1) % speeds.length;
    await _audioPlayerService.setSpeed(speeds[nextIndex]);
    notifyListeners();
  }

  /// 切换单句循环
  Future<void> toggleLoop() async {
    await _audioPlayerService.toggleLoopMode();
    notifyListeners();
  }

  /// 调整影子跟读延迟 (0.5s, 1.0s, 1.5s)
  void setShadowingDelay(double delay) {
    _shadowingDelay = delay;
    notifyListeners();
  }

  /// 播放或暂停原声示范
  Future<void> togglePlayReference() async {
    if (isPlaying) {
      await _audioPlayerService.pause();
    } else {
      await _audioPlayerService.play();
    }
    notifyListeners();
  }

  /// 开始录音
  Future<void> startRecording() async {
    // 停止示范播放，防止回音污染
    if (isPlaying && assignment.taskType != TaskType.shadowing) {
      await _audioPlayerService.pause();
    }

    _studentWave.clear();
    await _audioRecorderService.startRecording();

    // 如果是影子跟读模式，在设置的延迟时间后自动同步播放原声示范
    if (assignment.taskType == TaskType.shadowing) {
      Future.delayed(Duration(milliseconds: (_shadowingDelay * 1000).toInt()), () {
        if (isRecording) {
          _audioPlayerService.play();
        }
      });
    }
    notifyListeners();
  }

  /// 停止录音
  Future<void> stopRecording() async {
    await _audioRecorderService.stopRecording();
    if (isPlaying) {
      await _audioPlayerService.pause();
    }
    notifyListeners();
  }

  /// 试听自己刚录制的音频
  Future<void> togglePlayRecorded() async {
    if (_audioRecorderService.status == RecordingStatus.playingRecorded) {
      await _audioRecorderService.stopRecordedAudio();
    } else {
      await _audioRecorderService.playRecordedAudio();
    }
    notifyListeners();
  }

  /// 重录当前句子
  Future<void> reRecord() async {
    await _audioRecorderService.resetRecording();
    _studentWave.clear();
    _currentEvaluation = null;
    notifyListeners();
  }

  /// 提交并调用 AI 评测
  Future<SpeechEvaluation?> submitEvaluation() async {
    final recordedPath = _audioRecorderService.currentRecordingPath;
    if (recordedPath == null) return null;

    _isEvaluating = true;
    notifyListeners();

    try {
      final result = await _practiceRepository.evaluateRecording(
        targetText: currentItem.referenceText,
        audioPath: recordedPath,
        chosenAccent: _selectedAccent,
      );
      _currentEvaluation = result;
      return result;
    } finally {
      _isEvaluating = false;
      notifyListeners();
    }
  }

  /// 下一个句子条目
  Future<void> nextItem() async {
    if (_currentIndex < totalItems - 1) {
      _currentIndex++;
      _currentEvaluation = null;
      await _audioRecorderService.resetRecording();
      _studentWave.clear();
      await _loadCurrentItemAudio();
    }
  }

  /// 上一个句子条目
  Future<void> prevItem() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      _currentEvaluation = null;
      await _audioRecorderService.resetRecording();
      _studentWave.clear();
      await _loadCurrentItemAudio();
    }
  }

  @override
  void dispose() {
    _amplitudeSub?.cancel();
    _playerSub?.cancel();
    _audioPlayerService.dispose();
    _audioRecorderService.dispose();
    super.dispose();
  }
}
