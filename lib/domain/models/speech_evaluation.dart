enum WordStatus {
  correct,
  mispronounced,
  omitted,
  inserted;

  static WordStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'mispronounced':
        return WordStatus.mispronounced;
      case 'omitted':
      case 'missing':
        return WordStatus.omitted;
      case 'inserted':
        return WordStatus.inserted;
      default:
        return WordStatus.correct;
    }
  }
}

class WordDetail {
  final String word;
  final String? expectedWord;
  final String phoneticUk;
  final String phoneticUs;
  final WordStatus status;
  final double score;
  final String? feedbackTip;

  const WordDetail({
    required this.word,
    this.expectedWord,
    required this.phoneticUk,
    required this.phoneticUs,
    required this.status,
    required this.score,
    this.feedbackTip,
  });

  factory WordDetail.fromJson(Map<String, dynamic> json) {
    return WordDetail(
      word: json['word'] as String? ?? '',
      expectedWord: json['expectedWord'] as String?,
      phoneticUk: json['phoneticUk'] as String? ?? '',
      phoneticUs: json['phoneticUs'] as String? ?? '',
      status: WordStatus.fromString(json['status'] as String? ?? 'correct'),
      score: (json['score'] as num?)?.toDouble() ?? 80.0,
      feedbackTip: json['feedbackTip'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'word': word,
    'expectedWord': expectedWord,
    'phoneticUk': phoneticUk,
    'phoneticUs': phoneticUs,
    'status': status.name,
    'score': score,
    'feedbackTip': feedbackTip,
  };
}

class SpeechEvaluation {
  final String id;
  final double overallScore;
  final double intelligibilityScore; // 可理解度 (30%)
  final double contentScore;         // 内容完成度 (25%)
  final double fluencyScore;         // 流利度 (15%)
  final double stressIntonationScore;// 重音与语调 (15%)
  final double pronunciationScore;   // 音素发音 (10%)
  final String accentDetected;       // 检测到的口音倾向 (British / American / Mixed)
  final String recognizedText;       // ASR 识别出的学生录音文本
  final String targetText;           // 标准参考课文文本
  final double wpm;                  // 实际朗读语速 (Words Per Minute)
  final List<WordDetail> words;      // 逐词对齐诊断明细
  final List<String> suggestions;    // 针对性学习建议

  const SpeechEvaluation({
    required this.id,
    required this.overallScore,
    required this.intelligibilityScore,
    required this.contentScore,
    required this.fluencyScore,
    required this.stressIntonationScore,
    required this.pronunciationScore,
    required this.accentDetected,
    required this.recognizedText,
    required this.targetText,
    required this.wpm,
    required this.words,
    required this.suggestions,
  });

  factory SpeechEvaluation.fromJson(Map<String, dynamic> json) {
    return SpeechEvaluation(
      id: json['id'] as String? ?? '',
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      intelligibilityScore: (json['intelligibilityScore'] as num?)?.toDouble() ?? 0.0,
      contentScore: (json['contentScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['fluencyScore'] as num?)?.toDouble() ?? 0.0,
      stressIntonationScore: (json['stressIntonationScore'] as num?)?.toDouble() ?? 0.0,
      pronunciationScore: (json['pronunciationScore'] as num?)?.toDouble() ?? 0.0,
      accentDetected: json['accentDetected'] as String? ?? 'Mixed',
      recognizedText: json['recognizedText'] as String? ?? '',
      targetText: json['targetText'] as String? ?? '',
      wpm: (json['wpm'] as num?)?.toDouble() ?? 100.0,
      words: (json['words'] as List<dynamic>?)
              ?.map((e) => WordDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
