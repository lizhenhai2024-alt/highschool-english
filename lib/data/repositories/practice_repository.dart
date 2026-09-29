import '../../domain/models/accent_type.dart';
import '../../domain/models/speech_evaluation.dart';
import '../services/mock_data_service.dart';

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
