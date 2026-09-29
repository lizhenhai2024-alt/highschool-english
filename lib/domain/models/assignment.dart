import 'accent_type.dart';
import 'task_item.dart';

enum TaskType {
  listening,          // 双口音精听理解
  readAloud,          // 逐句朗读跟读
  shadowing,          // 影子跟读 (延迟训练)
  keywordRetell,      // 关键词复述
  topicSpeaking;      // 话题演讲与图片描述

  String get displayName {
    switch (this) {
      case TaskType.listening:
        return '双口音精听';
      case TaskType.readAloud:
        return '单句跟读';
      case TaskType.shadowing:
        return '影子跟读';
      case TaskType.keywordRetell:
        return '关键词复述';
      case TaskType.topicSpeaking:
        return '话题表达';
    }
  }

  String get badgeIcon {
    switch (this) {
      case TaskType.listening:
        return '🎧';
      case TaskType.readAloud:
        return '🗣️';
      case TaskType.shadowing:
        return '⚡';
      case TaskType.keywordRetell:
        return '🧩';
      case TaskType.topicSpeaking:
        return '🎯';
    }
  }

  static TaskType fromString(String val) {
    switch (val.toLowerCase()) {
      case 'listening':
        return TaskType.listening;
      case 'readaloud':
      case 'read_aloud':
        return TaskType.readAloud;
      case 'shadowing':
        return TaskType.shadowing;
      case 'keywordretell':
      case 'retelling':
        return TaskType.keywordRetell;
      default:
        return TaskType.topicSpeaking;
    }
  }
}

class Assignment {
  final String id;
  final String title;
  final String bookName;       // 如：必修一
  final String unitTitle;      // 如：Unit 1 Teenage Life
  final String sectionName;    // 如：Listening and Speaking
  final TaskType taskType;
  final AccentType accentMode;
  final String teacherName;
  final DateTime dueDate;
  final bool isCompleted;
  final double? lastScore;
  final List<TaskItem> items;

  const Assignment({
    required this.id,
    required this.title,
    required this.bookName,
    required this.unitTitle,
    required this.sectionName,
    required this.taskType,
    required this.accentMode,
    required this.teacherName,
    required this.dueDate,
    required this.isCompleted,
    this.lastScore,
    required this.items,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bookName: json['bookName'] as String? ?? '必修一',
      unitTitle: json['unitTitle'] as String? ?? 'Unit 1 Teenage Life',
      sectionName: json['sectionName'] as String? ?? 'Listening and Speaking',
      taskType: TaskType.fromString(json['taskType'] as String? ?? 'readAloud'),
      accentMode: AccentType.fromString(json['accentMode'] as String? ?? 'both'),
      teacherName: json['teacherName'] as String? ?? '李老师',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString()) ?? DateTime.now().add(const Duration(days: 3))
          : DateTime.now().add(const Duration(days: 3)),
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastScore: (json['lastScore'] as num?)?.toDouble(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
