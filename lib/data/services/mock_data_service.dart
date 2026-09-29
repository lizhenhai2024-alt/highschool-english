import 'package:highschool_english_student/domain/models/accent_type.dart';
import 'package:highschool_english_student/domain/models/assignment.dart';
import 'package:highschool_english_student/domain/models/speech_evaluation.dart';
import 'package:highschool_english_student/domain/models/task_item.dart';

class MockDataService {
  /// 获取所有教材册次的听说训练任务列表 (优先加载：人教版高中英语 选择性必修第一册「选必一」)
  static List<Assignment> getAssignments() {
    return [
      // =========================================================================
      // 人教版高中英语 选择性必修第一册 (选必一)
      // =========================================================================
      Assignment(
        id: 'task_selective_1_01',
        title: 'Unit 1 People of Achievement - 屠呦呦与青蒿素双口音精听与跟读',
        bookName: '选择性必修第一册',
        unitTitle: 'Unit 1 People of Achievement',
        sectionName: 'Reading and Thinking',
        taskType: TaskType.readAloud,
        accentMode: AccentType.both,
        teacherName: '张老师 (备课组长)',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        isCompleted: false,
        items: [
          TaskItem(
            id: 'item_sel1_1_1',
            orderIndex: 1,
            promptTitle: '第 1 句：诺贝尔奖殊荣与贡献',
            referenceText: 'Tu Youyou was awarded the Nobel Prize in Physiology or Medicine for her discovery of artemisinin.',
            translation: '屠呦呦因发现青蒿素而荣获诺贝尔生理学或医学奖。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 5.2,
            targetKeywords: ['Nobel Prize', 'Physiology or Medicine', 'discovery', 'artemisinin'],
            sentenceCues: [
              SentenceCue(
                index: 1,
                text: 'Tu Youyou was awarded the Nobel Prize in Physiology or Medicine for her discovery of artemisinin.',
                translation: '屠呦呦因发现青蒿素而荣获诺贝尔生理学或医学奖。',
                startTime: 0.0,
                endTime: 5.2,
                keywords: ['Nobel Prize', 'Physiology or Medicine', 'artemisinin'],
                phoneticsNote: '【英美音对比】artemisinin 英音 /ˌɑːtɪˈmiːsɪnɪn/，美音 /ˌɑːrt̬əˈmɪsənɪn/（注意美音 /r/ 卷舌与闪音）；awarded 美音带有明显卷舌 /əˈwɔːrdɪd/。',
              ),
            ],
          ),
          TaskItem(
            id: 'item_sel1_1_2',
            orderIndex: 2,
            promptTitle: '第 2 句：领衔科研攻关团队',
            referenceText: 'In 1969, she became the head of a research team that intended to find a cure for malaria.',
            translation: '1969 年，她担任了一支旨在寻找疟疾治愈方法的科研团队负责人。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 5.5,
            targetKeywords: ['head of a research team', 'intended to', 'cure', 'malaria'],
            sentenceCues: [
              SentenceCue(
                index: 2,
                text: 'In 1969, she became the head of a research team that intended to find a cure for malaria.',
                translation: '1969 年，她担任了一支旨在寻找疟疾治愈方法的科研团队负责人。',
                startTime: 0.0,
                endTime: 5.5,
                keywords: ['intended to', 'malaria', 'cure'],
                phoneticsNote: '【意群连读】head of a 产生连读 /ˌhed əv ə/；malaria 英音 /məˈleəriə/，美音 /məˈleriə/。',
              ),
            ],
          ),
          TaskItem(
            id: 'item_sel1_1_3',
            orderIndex: 3,
            promptTitle: '第 3 句：低温萃取青蒿有效成分',
            referenceText: 'After testing hundreds of herbs, she finally extracted the substance at a low temperature to preserve its properties.',
            translation: '在测试了数百种草药后，她最终在低温下提取出该物质以保留其药用活性。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 6.2,
            targetKeywords: ['extracted', 'substance', 'low temperature', 'preserve', 'properties'],
            sentenceCues: [
              SentenceCue(
                index: 3,
                text: 'After testing hundreds of herbs, she finally extracted the substance at a low temperature to preserve its properties.',
                translation: '在测试了数百种草药后，她最终在低温下提取出该物质以保留其药用活性。',
                startTime: 0.0,
                endTime: 6.2,
                keywords: ['extracted', 'substance', 'temperature', 'properties'],
                phoneticsNote: '【重音与音节】temperature 英音 /ˈtem.prə.tʃər/，美音 /ˈtem.pɚ.ə.tʃʊr/；substance 重音在首音节 /ˈsʌb.stəns/。',
              ),
            ],
          ),
        ],
      ),

      Assignment(
        id: 'task_selective_1_02',
        title: 'Unit 1 People of Achievement - 科学精神长句影子跟读',
        bookName: '选择性必修第一册',
        unitTitle: 'Unit 1 People of Achievement',
        sectionName: 'Listening and Speaking',
        taskType: TaskType.shadowing,
        accentMode: AccentType.both,
        teacherName: '张老师 (备课组长)',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        isCompleted: true,
        lastScore: 92.0,
        items: [
          TaskItem(
            id: 'item_sel1_2_1',
            orderIndex: 1,
            promptTitle: '奉献与担当情怀影子跟读',
            referenceText: 'To ensure patient safety, Tu Youyou and her teammates volunteered to test the medicine on themselves first.',
            translation: '为了确保患者安全，屠呦呦和她的队员们自愿先在自己身上进行试药。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 6.0,
            targetKeywords: ['ensure', 'volunteered to', 'test on themselves'],
            sentenceCues: [
              SentenceCue(
                index: 1,
                text: 'To ensure patient safety, Tu Youyou and her teammates volunteered to test the medicine on themselves first.',
                translation: '为了确保患者安全，屠呦呦和她的队员们自愿先在自己身上进行试药。',
                startTime: 0.0,
                endTime: 6.0,
                keywords: ['volunteered', 'patient safety'],
                phoneticsNote: '【英美音差异】volunteered: 英音 /ˌvɒl.ənˈtɪəd/，美音 /ˌvɑːl.ənˈtɪrd/；注意 first 的词尾爆破音 /t/ 不可漏读。',
              ),
            ],
          ),
        ],
      ),

      Assignment(
        id: 'task_selective_1_03',
        title: 'Unit 2 Looking into the Future - 智能家居生活双口音精听',
        bookName: '选择性必修第一册',
        unitTitle: 'Unit 2 Looking into the Future',
        sectionName: 'Listening and Talking',
        taskType: TaskType.listening,
        accentMode: AccentType.both,
        teacherName: '李老师',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        isCompleted: false,
        items: [
          TaskItem(
            id: 'item_sel1_3_1',
            orderIndex: 1,
            promptTitle: '智能家居对日常生活的变革',
            referenceText: 'In the future, smart homes will use advanced sensors to monitor our health and prevent accidents.',
            translation: '在未来，智能家居将使用先进的传感器来监测我们的健康并预防事故。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 5.6,
            targetKeywords: ['smart homes', 'advanced sensors', 'monitor', 'prevent accidents'],
            sentenceCues: [
              SentenceCue(
                index: 1,
                text: 'In the future, smart homes will use advanced sensors to monitor our health and prevent accidents.',
                translation: '在未来，智能家居将使用先进的传感器来监测我们的健康并预防事故。',
                startTime: 0.0,
                endTime: 5.6,
                keywords: ['advanced sensors', 'monitor'],
                phoneticsNote: '【核心元音对比】advanced: 英音 /ədˈvɑːnst/ vs 美音 /ədˈvænst/（典型 /ɑː/ 与 /æ/ 发音口型差异）。',
              ),
            ],
          ),
        ],
      ),

      Assignment(
        id: 'task_selective_1_04',
        title: 'Unit 1 People of Achievement - 30秒关键词复述青蒿素发现史',
        bookName: '选择性必修第一册',
        unitTitle: 'Unit 1 People of Achievement',
        sectionName: 'Reading for Writing',
        taskType: TaskType.keywordRetell,
        accentMode: AccentType.both,
        teacherName: '张老师 (备课组长)',
        dueDate: DateTime.now().add(const Duration(days: 6)),
        isCompleted: false,
        items: [
          TaskItem(
            id: 'item_sel1_4_1',
            orderIndex: 1,
            promptTitle: '青蒿素研发历程与科学奉献',
            referenceText: 'Through persistent research and ancient medical literature, Tu Youyou discovered artemisinin and saved millions of lives.',
            translation: '通过坚持不懈的探究和查阅古代医学典籍，屠呦呦发现了青蒿素并拯救了数百万人的生命。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 6.5,
            targetKeywords: ['persistent research', 'ancient medical literature', 'artemisinin', 'saved millions of lives'],
            sentenceCues: [
              SentenceCue(
                index: 1,
                text: 'Through persistent research and ancient medical literature, Tu Youyou discovered artemisinin and saved millions of lives.',
                translation: '通过坚持不懈的探究和查阅古代医学典籍，屠呦呦发现了青蒿素并拯救了数百万人的生命。',
                startTime: 0.0,
                endTime: 6.5,
                keywords: ['persistent', 'literature', 'millions of lives'],
                phoneticsNote: '【易读错词】literature 英音 /ˈlɪt.rə.tʃər/，美音 /ˈlɪt̬.ɚ.ə.tʃʊr/；persistent 重音在第二音节 /pəˈsɪs.tənt/。',
              ),
            ],
          ),
        ],
      ),

      // =========================================================================
      // 人教版高中英语 必修第一册 (选修备用)
      // =========================================================================
      Assignment(
        id: 'task_compulsory_1_01',
        title: 'Unit 1 Teenage Life - 课文跟读与双口音精听',
        bookName: '必修第一册',
        unitTitle: 'Unit 1 Teenage Life',
        sectionName: 'Listening and Speaking',
        taskType: TaskType.readAloud,
        accentMode: AccentType.both,
        teacherName: '李老师',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        isCompleted: false,
        items: [
          TaskItem(
            id: 'item_comp1_1_1',
            orderIndex: 1,
            promptTitle: '第一句：高中生活的挑战',
            referenceText: 'Going from junior high school to senior high school is a really big challenge.',
            translation: '从初中升入高中确实是一个很大的挑战。',
            britishAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_british_accent.ogg',
            americanAudioUrl: 'https://actions.google.com/sounds/v1/speech/female_american_accent.ogg',
            durationSec: 4.2,
            targetKeywords: ['senior high school', 'challenge'],
            sentenceCues: [
              SentenceCue(
                index: 1,
                text: 'Going from junior high school to senior high school is a really big challenge.',
                translation: '从初中升入高中确实是一个很大的挑战。',
                startTime: 0.0,
                endTime: 4.2,
                keywords: ['challenge', 'senior high school'],
                phoneticsNote: 'schedule: 英音 /ˈʃedjuːl/ vs 美音 /ˈskedʒuːl/；注意 challenge 的首音节重音 /ˈtʃæl.ɪndʒ/。',
              ),
            ],
          ),
        ],
      ),
    ];
  }

  /// 模拟符合人教版课标的 AI 口语评测引擎，支持选择性必修一课文关键词精确对齐
  static Future<SpeechEvaluation> mockEvaluateSubmission({
    required String targetText,
    required String audioPath,
    required AccentType chosenAccent,
  }) async {
    // 模拟云端 ASR 与模型评测延时 1.5 秒
    await Future.delayed(const Duration(milliseconds: 1500));

    final cleanText = targetText.replaceAll('.', '').replaceAll(',', '');
    final wordsList = cleanText.split(' ');
    final wordDetails = <WordDetail>[];

    for (int i = 0; i < wordsList.length; i++) {
      final w = wordsList[i];
      final lower = w.toLowerCase();

      if (lower == 'artemisinin') {
        // 青蒿素专项诊断
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/ˌɑːtɪˈmiːsɪnɪn/',
          phoneticUs: '/ˌɑːrt̬əˈmɪsənɪn/',
          status: WordStatus.correct,
          score: 96,
          feedbackTip: '青蒿素专业生词发音清晰，${chosenAccent == AccentType.british ? '英音元音饱满' : '美音卷舌与闪音到位'}',
        ));
      } else if (lower == 'physiology') {
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/ˌfɪz.iˈɒl.ə.dʒi/',
          phoneticUs: '/ˌfɪz.iˈɑː.lə.dʒi/',
          status: WordStatus.correct,
          score: 93,
          feedbackTip: '次重音与主重音定位准确',
        ));
      } else if (lower == 'malaria') {
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/məˈleəriə/',
          phoneticUs: '/məˈleriə/',
          status: WordStatus.correct,
          score: 92,
          feedbackTip: '双元音滑动自然',
        ));
      } else if (lower == 'temperature') {
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/ˈtem.prə.tʃər/',
          phoneticUs: '/ˈtem.pɚ.ə.tʃʊr/',
          status: WordStatus.correct,
          score: 88,
          feedbackTip: '注意三音节节奏，不要多读弱音节',
        ));
      } else if (lower == 'substance') {
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/ˈsʌb.stəns/',
          phoneticUs: '/ˈsʌb.stəns/',
          status: WordStatus.correct,
          score: 95,
          feedbackTip: '首音节重读突出',
        ));
      } else {
        wordDetails.add(WordDetail(
          word: w,
          phoneticUk: '/$w/',
          phoneticUs: '/$w/',
          status: WordStatus.correct,
          score: 91,
        ));
      }
    }

    return SpeechEvaluation(
      id: 'eval_sel1_${DateTime.now().millisecondsSinceEpoch}',
      overallScore: 92.5,
      intelligibilityScore: 94.0,
      contentScore: 95.0,
      fluencyScore: 89.0,
      stressIntonationScore: 91.0,
      pronunciationScore: 93.0,
      accentDetected: chosenAccent == AccentType.british ? 'British (RP英音特征突出)' : 'American (GA美音特征突出)',
      recognizedText: targetText,
      targetText: targetText,
      wpm: 122.0,
      words: wordDetails,
      suggestions: [
        '【选必一专项评价】课文核心专业词汇 "artemisinin" 与 "Physiology or Medicine" 辨音和发音极其标准！',
        '【意群节奏】长句 "After testing hundreds of herbs..." 的状语从句停顿节点清晰，节奏感佳。',
        '【英美音建议】当前选用${chosenAccent.displayName}，注意在日常诵读中保持元音开口度与重音的统一性。',
      ],
    );
  }
}
