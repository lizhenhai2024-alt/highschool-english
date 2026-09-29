import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../../domain/models/accent_type.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  AccentType _currentAccent = AccentType.british;
  String _britishUrl = '';
  String _americanUrl = '';
  double _playbackSpeed = 1.0;
  bool _isLooping = false;

  AudioPlayer get player => _player;
  AccentType get currentAccent => _currentAccent;
  double get playbackSpeed => _playbackSpeed;
  bool get isLooping => _isLooping;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 加载当前条目的双口音音频地址
  Future<void> setAudioSources({
    required String britishUrl,
    required String americanUrl,
    AccentType initialAccent = AccentType.british,
  }) async {
    _britishUrl = britishUrl;
    _americanUrl = americanUrl;
    _currentAccent = initialAccent;

    final targetUrl = _currentAccent == AccentType.british ? _britishUrl : _americanUrl;
    if (targetUrl.isNotEmpty) {
      try {
        await _player.setUrl(targetUrl);
        await _player.setSpeed(_playbackSpeed);
        await _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
      } catch (e) {
        // 音频加载异常容错
      }
    }
  }

  /// 一键平滑切换口音 (英音 RP <-> 美音 GA)，保留当前播放进度
  Future<void> switchAccent(AccentType newAccent) async {
    if (_currentAccent == newAccent && newAccent != AccentType.both) return;

    final currentPosition = _player.position;
    final isPlaying = _player.playing;

    _currentAccent = newAccent;
    final newUrl = _currentAccent == AccentType.american ? _americanUrl : _britishUrl;

    if (newUrl.isNotEmpty) {
      try {
        await _player.setUrl(newUrl);
        await _player.seek(currentPosition);
        if (isPlaying) {
          await _player.play();
        }
      } catch (e) {
        // 口音切换容错
      }
    }
  }

  /// 调整播放速度 (0.8x 慢速精听, 1.0x 正常, 1.2x 提速)
  Future<void> setSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setSpeed(speed);
  }

  /// 切换单句循环模式
  Future<void> toggleLoopMode() async {
    _isLooping = !_isLooping;
    await _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
  }

  /// 跳转至指定秒数
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
