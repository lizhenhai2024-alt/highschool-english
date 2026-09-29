import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DualWaveformView extends StatelessWidget {
  final List<double> referenceWave;
  final List<double> studentWave;
  final double playbackProgress; // 0.0 ~ 1.0
  final bool isRecording;
  final double shadowingDelaySeconds;

  const DualWaveformView({
    super.key,
    required this.referenceWave,
    required this.studentWave,
    this.playbackProgress = 0.0,
    this.isRecording = false,
    this.shadowingDelaySeconds = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // 暗深蓝背景，专业音频波形质感
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 上轨：原声示范波形
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '示范声波 (Reference)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (shadowingDelaySeconds > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '影子延迟: ${shadowingDelaySeconds.toStringAsFixed(1)}s',
                    style: const TextStyle(
                      color: Color(0xFFD8B4FE),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: _buildWaveTrack(
              amplitudes: referenceWave,
              barColor: AppTheme.secondaryCyan,
              progress: playbackProgress,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.white12, height: 1),
          ),

          // 下轨：学生录音波形
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isRecording ? Colors.redAccent : AppTheme.accentOrange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isRecording ? '正在实时采集录音 (Live Mic)...' : '学生录音波形 (Your Voice)',
                style: TextStyle(
                  color: isRecording ? Colors.redAccent : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: _buildWaveTrack(
              amplitudes: studentWave.isEmpty ? _generatePlaceholderBars() : studentWave,
              barColor: isRecording ? Colors.redAccent : AppTheme.accentOrange,
              progress: isRecording ? 1.0 : playbackProgress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveTrack({
    required List<double> amplitudes,
    required Color barColor,
    required double progress,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barCount = (constraints.maxWidth / 6).floor().clamp(10, 80);
        final displayList = <double>[];

        if (amplitudes.isEmpty) {
          for (int i = 0; i < barCount; i++) {
            displayList.add(0.2);
          }
        } else {
          // 均匀采样
          for (int i = 0; i < barCount; i++) {
            final index = ((i / barCount) * amplitudes.length).floor().clamp(0, amplitudes.length - 1);
            displayList.add(amplitudes[index]);
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(displayList.length, (index) {
            final activeProgressIndex = (progress * displayList.length).floor();
            final isActive = index <= activeProgressIndex;
            final barHeight = (displayList[index] * 40).clamp(6.0, 44.0);

            return Container(
              width: 3.5,
              height: barHeight,
              decoration: BoxDecoration(
                color: isActive ? barColor : Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  static List<double> _generatePlaceholderBars() {
    final rand = Random(42);
    return List.generate(40, (index) => 0.15 + rand.nextDouble() * 0.5);
  }
}
