import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highschool_english_student/domain/models/accent_type.dart';
import 'package:highschool_english_student/domain/models/assignment.dart';
import 'package:highschool_english_student/domain/models/speech_evaluation.dart';
import 'package:highschool_english_student/data/repositories/assignment_repository.dart';
import 'package:highschool_english_student/data/repositories/practice_repository.dart';
import 'package:highschool_english_student/ui/features/submission/views/evaluation_sheet.dart';

void main() {
  group('人教版高中英语 选择性必修第一册 (选必一) 核心模型与仓库测试', () {
    test('AccentType parsing and display names', () {
      expect(AccentType.fromString('british'), AccentType.british);
      expect(AccentType.fromString('american'), AccentType.american);
      expect(AccentType.fromString('both'), AccentType.both);
      expect(AccentType.british.displayName, '英音 (RP)');
      expect(AccentType.american.displayName, '美音 (GA)');
    });

    test('TaskType parsing and attributes', () {
      expect(TaskType.fromString('readAloud'), TaskType.readAloud);
      expect(TaskType.fromString('shadowing'), TaskType.shadowing);
      expect(TaskType.fromString('retelling'), TaskType.keywordRetell);
      expect(TaskType.shadowing.displayName, '影子跟读');
    });

    test('AssignmentRepository loads 选择性必修第一册 (选必一) Unit 1 课文', () async {
      final repo = AssignmentRepository();
      final assignments = await repo.getAssignments(forceRefresh: true);

      expect(assignments.isNotEmpty, true);
      // 验证优先加载「选择性必修第一册」
      final sel1Tasks = assignments.where((a) => a.bookName == '选择性必修第一册').toList();
      expect(sel1Tasks.isNotEmpty, true);

      final tuTask = sel1Tasks.first;
      expect(tuTask.unitTitle, 'Unit 1 People of Achievement');
      expect(tuTask.items.first.referenceText, contains('Tu Youyou was awarded the Nobel Prize'));
      expect(tuTask.items.first.sentenceCues.first.phoneticsNote, contains('artemisinin'));
    });

    test('PracticeRepository produces complete SpeechEvaluation for Tu Youyou text', () async {
      final repo = PracticeRepository();
      final eval = await repo.evaluateRecording(
        targetText: 'Tu Youyou was awarded the Nobel Prize in Physiology or Medicine for her discovery of artemisinin.',
        audioPath: '/mock/path/audio.m4a',
        chosenAccent: AccentType.british,
      );

      expect(eval.overallScore, greaterThan(85.0));
      expect(eval.intelligibilityScore, greaterThan(85.0));
      expect(eval.words.any((w) => w.word.toLowerCase() == 'artemisinin'), true);
      expect(eval.suggestions.isNotEmpty, true);
    });

    testWidgets('EvaluationSheet UI component compiles and renders cleanly', (tester) async {
      const eval = SpeechEvaluation(
        id: 'mock_eval_1',
        overallScore: 92.0,
        intelligibilityScore: 90.0,
        contentScore: 95.0,
        fluencyScore: 88.0,
        stressIntonationScore: 92.0,
        pronunciationScore: 91.0,
        accentDetected: '英音 (RP)',
        recognizedText: 'Tu Youyou was awarded the Nobel Prize in Physiology or Medicine.',
        targetText: 'Tu Youyou was awarded the Nobel Prize in Physiology or Medicine.',
        wpm: 110.0,
        words: [
          WordDetail(
            word: 'Tu',
            phoneticUk: '/tuː/',
            phoneticUs: '/tuː/',
            status: WordStatus.correct,
            score: 95.0,
          ),
          WordDetail(
            word: 'artemisinin',
            phoneticUk: '/ˌɑːtɪˈmiːsɪnɪn/',
            phoneticUs: '/ˌɑːrt̬əˈmɪsənɪn/',
            status: WordStatus.correct,
            score: 96.0,
            feedbackTip: '专业生词发音准确',
          ),
        ],
        suggestions: ['注意连读和意群停顿', '保持稳定的语调升降'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EvaluationSheet(
              evaluation: eval,
              hasNext: true,
              onRetry: () {},
              onNext: () {},
            ),
          ),
        ),
      );

      expect(find.text('口语评测总分'), findsOneWidget);
      expect(find.text('针对性提升建议'), findsOneWidget);
    });
  });
}
