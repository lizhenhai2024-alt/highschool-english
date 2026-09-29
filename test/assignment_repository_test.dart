import 'package:flutter_test/flutter_test.dart';
import 'package:highschool_english_student/domain/models/accent_type.dart';
import 'package:highschool_english_student/domain/models/assignment.dart';
import 'package:highschool_english_student/data/repositories/assignment_repository.dart';
import 'package:highschool_english_student/data/repositories/practice_repository.dart';

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
  });
}
