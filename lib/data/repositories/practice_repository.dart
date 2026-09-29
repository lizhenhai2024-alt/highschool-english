import 'package:highschool_english_student/domain/models/accent_type.dart';
import 'package:highschool_english_student/domain/models/speech_evaluation.dart';
import 'package:highschool_english_student/data/services/mock_data_service.dart';

class PracticeRepository {
  Future<SpeechEvaluation> evaluateRecording({
    required String targetText,
    required String audioPath,
    required AccentType chosenAccent,
  }) async {
    return await MockDataService.mockEvaluateSubmission(
      targetText: targetText,
      audioPath: audioPath,
      chosenAccent: chosenAccent,
    );
  }
}
