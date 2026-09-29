import 'package:flutter/material.dart';
import '../../../domain/models/speech_evaluation.dart';
import '../../core/theme/app_theme.dart';

class EvaluationSheet extends StatelessWidget {
  final SpeechEvaluation evaluation;
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final bool hasNext;

  const EvaluationSheet({
    super.key,
    required this.evaluation,
    required this.onRetry,
    required this.onNext,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶端拖拽指示条
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. 总分与口音倾向卡片
            _buildScoreHeader(),
            const SizedBox(height: 16),

            // 2. 六维能力细分条
            const Text('多维能力评测诊断', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
            const SizedBox(height: 8),
            _buildScoreProgress('可理解度 (听感自然度)', evaluation.intelligibilityScore, 30),
            _buildScoreProgress('内容完成度 (关键词覆盖)', evaluation.contentScore, 25),
            _buildScoreProgress('流利度 (${evaluation.wpm.toStringAsFixed(0)} WPM 语速)', evaluation.fluencyScore, 15),
            _buildScoreProgress('重音与语调 (升降调/意群)', evaluation.stressIntonationScore, 15),
            _buildScoreProgress('音素发音 (元辅音爆破)', evaluation.pronunciationScore, 10),
            const SizedBox(height: 16),

            // 3. 逐词发音诊断与音标差异提示
            const Text('逐词诊断与音标比对', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
            const SizedBox(height: 8),
            _buildWordsFlow(context),
            const SizedBox(height: 16),

            // 4. AI 教学改进建议
            if (evaluation.suggestions.isNotEmpty) ...[
              const Text('针对性提升建议', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              const SizedBox(height: 8),
              ...evaluation.suggestions.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡 ', style: TextStyle(fontSize: 13)),
                        Expanded(
                          child: Text(s, style: const TextStyle(fontSize: 13, color: AppTheme.textMain, height: 1.4)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
            ],

            // 5. 底部操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetry,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('重录再练一次'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(hasNext ? '继续下一句' : '完成本次训练'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    evaluation.overallScore.toStringAsFixed(0),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('口语评测总分', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  const SizedBox(height: 4),
                  Text(
                    '评测依据：人教版高中听说课标标准',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text('口音倾向', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  evaluation.accentDetected,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreProgress(String label, double score, int weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (score / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  score >= 90 ? Colors.green : (score >= 75 ? AppTheme.primaryBlue : AppTheme.accentOrange),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 45,
            child: Text(
              '${score.toStringAsFixed(0)}分',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMain),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordsFlow(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      children: evaluation.words.map((w) {
        final isCorrect = w.status == WordStatus.correct;
        final hasTip = w.feedbackTip != null;

        return Tooltip(
          message: hasTip ? '${w.feedbackTip}\n英: ${w.phoneticUk} | 美: ${w.phoneticUs}' : '英: ${w.phoneticUk} | 美: ${w.phoneticUs}',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                width: hasTip ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  w.word,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
                Text(
                  w.phoneticUk,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
