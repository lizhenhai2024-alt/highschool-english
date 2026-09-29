import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/practice_repository.dart';
import '../../../domain/models/assignment.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/accent_toggle_bar.dart';
import '../../core/widgets/waveform_view.dart';
import '../view_models/practice_view_model.dart';
import '../../submission/views/evaluation_sheet.dart';

class PracticeScreen extends StatelessWidget {
  final Assignment assignment;

  const PracticeScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PracticeViewModel(
        assignment: assignment,
        practiceRepository: PracticeRepository(),
      ),
      child: const _PracticeScreenContent(),
    );
  }
}

class _PracticeScreenContent extends StatefulWidget {
  const _PracticeScreenContent();

  @override
  State<_PracticeScreenContent> createState() => _PracticeScreenContentState();
}

class _PracticeScreenContentState extends State<_PracticeScreenContent> {
  bool _showTranslation = true;

  void _showEvaluationResult(BuildContext context, PracticeViewModel viewModel) {
    final eval = viewModel.currentEvaluation;
    if (eval == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EvaluationSheet(
        evaluation: eval,
        hasNext: viewModel.currentIndex < viewModel.totalItems - 1,
        onRetry: () {
          Navigator.pop(context);
          viewModel.reRecord();
        },
        onNext: () {
          Navigator.pop(context);
          if (viewModel.currentIndex < viewModel.totalItems - 1) {
            viewModel.nextItem();
          } else {
            Navigator.pop(context); // 训练结束返回主页
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 恭喜完成本次听说训练！成绩已同步至班级学情库。')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PracticeViewModel>();
    final currentItem = viewModel.currentItem;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              viewModel.assignment.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${viewModel.assignment.taskType.displayName} · 第 ${viewModel.currentIndex + 1} / ${viewModel.totalItems} 句',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.g_translate_outlined,
              color: _showTranslation ? AppTheme.primaryBlue : AppTheme.textSecondary,
            ),
            tooltip: '切换中文释义',
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // 1. 口音与语速控制条
                  _buildControlHeader(viewModel),
                  const SizedBox(height: 12),

                  // 2. 目标句子卡片
                  _buildSentenceCard(viewModel, currentItem),
                  const SizedBox(height: 14),

                  // 3. 影子跟读专属延迟调节滑块 (仅在影子模式呈现)
                  if (viewModel.assignment.taskType == TaskType.shadowing) ...[
                    _buildShadowingDelaySlider(viewModel),
                    const SizedBox(height: 14),
                  ],

                  // 4. 双轨波形对比展示 (示范轨 + 学生录音轨)
                  DualWaveformView(
                    referenceWave: viewModel.referenceWave,
                    studentWave: viewModel.studentWave,
                    playbackProgress: viewModel.playbackProgress,
                    isRecording: viewModel.isRecording,
                    shadowingDelaySeconds: viewModel.assignment.taskType == TaskType.shadowing ? viewModel.shadowingDelay : 0.0,
                  ),
                  const SizedBox(height: 14),

                  // 5. 英美音音标对比与重音注意事项
                  if (currentItem.sentenceCues.isNotEmpty && currentItem.sentenceCues.first.phoneticsNote != null)
                    _buildPhoneticsTipCard(currentItem.sentenceCues.first.phoneticsNote!),
                ],
              ),
            ),

            // 6. 底部固定录音与操作主控台
            _buildBottomActionBar(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildControlHeader(PracticeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 双口音切换
        AccentToggleBar(
          currentAccent: viewModel.selectedAccent,
          onAccentChanged: (accent) => viewModel.switchAccent(accent),
        ),

        // 语速与循环控制
        Row(
          children: [
            // 语速切换胶囊
            GestureDetector(
              onTap: () => viewModel.cyclePlaybackSpeed(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '${viewModel.playerService.playbackSpeed}x 语速',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 单句循环按钮
            GestureDetector(
              onTap: () => viewModel.toggleLoop(),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: viewModel.playerService.isLooping ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: viewModel.playerService.isLooping ? AppTheme.primaryBlue : Colors.grey.shade300,
                  ),
                ),
                child: Icon(
                  Icons.repeat,
                  size: 18,
                  color: viewModel.playerService.isLooping ? AppTheme.primaryBlue : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSentenceCard(PracticeViewModel viewModel, dynamic currentItem) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentItem.promptTitle,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
              GestureDetector(
                onTap: () => viewModel.togglePlayReference(),
                child: Row(
                  children: [
                    Icon(
                      viewModel.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: AppTheme.secondaryCyan,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      viewModel.isPlaying ? '正在示范' : '听示范原声',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryCyan),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 核心英文大文本
          Text(
            currentItem.referenceText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
              height: 1.45,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),

          // 中文释义
          if (_showTranslation) ...[
            Text(
              currentItem.translation,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 12),
          ],

          // 核心关键词意群 Chips
          if (currentItem.targetKeywords.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: (currentItem.targetKeywords as List<String>).map((kw) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Text(
                    '★ $kw',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.amber.shade900),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildShadowingDelaySlider(PracticeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accentPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.av_timer, color: AppTheme.accentPurple, size: 20),
          const SizedBox(width: 8),
          const Text('影子延迟:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
          Expanded(
            child: Slider(
              value: viewModel.shadowingDelay,
              min: 0.5,
              max: 1.5,
              divisions: 2,
              activeColor: AppTheme.accentPurple,
              label: '${viewModel.shadowingDelay}秒',
              onChanged: (val) => viewModel.setShadowingDelay(val),
            ),
          ),
          Text('${viewModel.shadowingDelay}s', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPhoneticsTipCard(String note) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔍 ', style: TextStyle(fontSize: 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('英美音发音与连读要点提示：', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                const SizedBox(height: 2),
                Text(note, style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, PracticeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. 上一句
              IconButton(
                onPressed: viewModel.currentIndex > 0 ? () => viewModel.prevItem() : null,
                icon: const Icon(Icons.skip_previous),
                tooltip: '上一句',
              ),

              // 2. 试听自己录音
              if (viewModel.hasRecordedAudio && !viewModel.isRecording)
                IconButton(
                  onPressed: () => viewModel.togglePlayRecorded(),
                  icon: const Icon(Icons.volume_up, color: AppTheme.secondaryCyan),
                  tooltip: '试听我的录音',
                ),

              // 3. 核心麦克风录音按钮
              GestureDetector(
                onTap: () async {
                  if (viewModel.isRecording) {
                    await viewModel.stopRecording();
                  } else {
                    await viewModel.startRecording();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: viewModel.isRecording ? Colors.redAccent : AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (viewModel.isRecording ? Colors.redAccent : AppTheme.primaryBlue).withOpacity(0.4),
                        blurRadius: viewModel.isRecording ? 16 : 8,
                        spreadRadius: viewModel.isRecording ? 4 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    viewModel.isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              // 4. 重录按钮
              if (viewModel.hasRecordedAudio && !viewModel.isRecording)
                IconButton(
                  onPressed: () => viewModel.reRecord(),
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  tooltip: '清除重录',
                ),

              // 5. 下一句
              IconButton(
                onPressed: viewModel.currentIndex < viewModel.totalItems - 1 ? () => viewModel.nextItem() : null,
                icon: const Icon(Icons.skip_next),
                tooltip: '下一句',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 录音状态提示或提交评测按钮
          if (viewModel.isRecording)
            const Text('正在录音...再次点击大按钮停止', style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold))
          else if (viewModel.hasRecordedAudio)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: viewModel.isEvaluating
                    ? null
                    : () async {
                        final res = await viewModel.submitEvaluation();
                        if (res != null && context.mounted) {
                          _showEvaluationResult(context, viewModel);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryCyan,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: viewModel.isEvaluating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(viewModel.isEvaluating ? '正在进行 AI 口语多维评测...' : '提交录音并查看 AI 诊断报告'),
              ),
            )
          else
            const Text('点击中间蓝色麦克风开始录音跟读', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
