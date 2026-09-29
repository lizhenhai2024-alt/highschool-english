import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

enum RecordingStatus {
  idle,
  recording,
  paused,
  stopped,
  playingRecorded,
}

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _playbackPlayer = AudioPlayer();

  RecordingStatus _status = RecordingStatus.idle;
  String? _currentRecordingPath;
  Timer? _amplitudeTimer;
  final StreamController<double> _amplitudeController = StreamController<double>.broadcast();

  RecordingStatus get status => _status;
  String? get currentRecordingPath => _currentRecordingPath;
  Stream<double> get amplitudeStream => _amplitudeController.stream;
  Stream<PlayerState> get playbackStateStream => _playbackPlayer.playerStateStream;

  /// 检查麦克风权限
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  /// 开始录音并定期采集振幅波形
  Future<void> startRecording() async {
    final hasPerm = await hasPermission();
    if (!hasPerm) {
      throw Exception('未授予麦克风权限，无法开始口语录音');
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = 'record_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _currentRecordingPath = '${tempDir.path}/$fileName';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _currentRecordingPath!,
    );

    _status = RecordingStatus.recording;

    // 定时采集音频振幅用于绘制实时波形
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (_status == RecordingStatus.recording) {
        final amp = await _recorder.getAmplitude();
        // 将 dB (-60dB ~ 0dB) 映射为 0.0 ~ 1.0 的正规化振幅
        final currentDb = amp.current;
        final normalized = ((currentDb + 60) / 60).clamp(0.05, 1.0);
        _amplitudeController.add(normalized);
      }
    });
  }

  /// 停止录音并返回文件路径
  Future<String?> stopRecording() async {
    _amplitudeTimer?.cancel();
    final path = await _recorder.stop();
    _status = RecordingStatus.stopped;
    _currentRecordingPath = path;
    return path;
  }

  /// 试听学生自己刚录制的音频
  Future<void> playRecordedAudio() async {
    if (_currentRecordingPath == null) return;
    final file = File(_currentRecordingPath!);
    if (!await file.exists()) return;

    await _playbackPlayer.setFilePath(_currentRecordingPath!);
    _status = RecordingStatus.playingRecorded;
    await _playbackPlayer.play();
  }

  /// 暂停或停止试听
  Future<void> stopRecordedAudio() async {
    await _playbackPlayer.stop();
    _status = RecordingStatus.stopped;
  }

  /// 重置并清除当前录音
  Future<void> resetRecording() async {
    _amplitudeTimer?.cancel();
    await _playbackPlayer.stop();
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    _status = RecordingStatus.idle;
    _currentRecordingPath = null;
  }

  void dispose() {
    _amplitudeTimer?.cancel();
    _amplitudeController.close();
    _recorder.dispose();
    _playbackPlayer.dispose();
  }
}
