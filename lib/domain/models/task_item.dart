import 'package:highschool_english_student/domain/models/accent_type.dart';

class SentenceCue {
  final int index;
  final String text;
  final String translation;
  final double startTime;
  final double endTime;
  final List<String> keywords;
  final String? phoneticsNote; // 英美音音标对比说明，如 schedule: UK /ˈʃedjuːl/ vs US /ˈskedʒuːl/

  const SentenceCue({
    required this.index,
    required this.text,
    required this.translation,
    required this.startTime,
    required this.endTime,
    required this.keywords,
    this.phoneticsNote,
  });

  factory SentenceCue.fromJson(Map<String, dynamic> json) {
    return SentenceCue(
      index: json['index'] as int? ?? 1,
      text: json['text'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      startTime: (json['startTime'] as num?)?.toDouble() ?? 0.0,
      endTime: (json['endTime'] as num?)?.toDouble() ?? 0.0,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      phoneticsNote: json['phoneticsNote'] as String?,
    );
  }
}

class TaskItem {
  final String id;
  final int orderIndex;
  final String promptTitle;
  final String referenceText;
  final String translation;
  final String britishAudioUrl;
  final String americanAudioUrl;
  final double durationSec;
  final List<SentenceCue> sentenceCues;
  final List<String> targetKeywords;

  const TaskItem({
    required this.id,
    required this.orderIndex,
    required this.promptTitle,
    required this.referenceText,
    required this.translation,
    required this.britishAudioUrl,
    required this.americanAudioUrl,
    required this.durationSec,
    required this.sentenceCues,
    required this.targetKeywords,
  });

  String getAudioUrl(AccentType accent) {
    switch (accent) {
      case AccentType.british:
        return britishAudioUrl;
      case AccentType.american:
        return americanAudioUrl;
      case AccentType.both:
        return britishAudioUrl; // 默认使用英音作为初试主音频
    }
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String? ?? '',
      orderIndex: json['orderIndex'] as int? ?? 0,
      promptTitle: json['promptTitle'] as String? ?? '',
      referenceText: json['referenceText'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      britishAudioUrl: json['britishAudioUrl'] as String? ?? '',
      americanAudioUrl: json['americanAudioUrl'] as String? ?? '',
      durationSec: (json['durationSec'] as num?)?.toDouble() ?? 0.0,
      sentenceCues: (json['sentenceCues'] as List<dynamic>?)
              ?.map((e) => SentenceCue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      targetKeywords: (json['targetKeywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
