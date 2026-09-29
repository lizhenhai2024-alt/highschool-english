# 人教版高中英语听说训练教师平台

一个面向高中英语教师的教学辅助 Web 应用，围绕人教版高中英语教材，提供英音与美音双口音听力、跟读、口语录音、复述训练、课堂任务布置和班级学情分析。

> 当前项目处于 MVP 原型开发阶段。
>
> 产品定位：教师备课与听说训练管理平台 + **学生端 Android 原生移动训练 App**。
>
> 核心首发教材：**新课标人教版高中英语 选择性必修第一册（选必一）**，深度内置 Unit 1《People of Achievement》（屠呦呦与青蒿素发现史）、Unit 2《Looking into the Future》（智能科技）等全套双口音精听、跟读、影子跟读与关键词复述训练。


---

## 目录

- [项目简介](#项目简介)
- [产品目标](#产品目标)
- [核心用户](#核心用户)
- [核心功能](#核心功能)
- [MVP 范围](#mvp-范围)
- [典型使用流程](#典型使用流程)
- [技术方案](#技术方案)
- [项目结构](#项目结构)
- [数据模型](#数据模型)
- [本地开发](#本地开发)
- [环境变量](#环境变量)
- [开发规范](#开发规范)
- [语音功能设计](#语音功能设计)
- [AI 功能设计](#ai-功能设计)
- [隐私、版权与安全](#隐私版权与安全)
- [开发路线图](#开发路线图)
- [验收标准](#验收标准)
- [项目原则](#项目原则)
- [许可证](#许可证)
- [当前开发任务](#当前开发任务)

---

## 项目简介

本项目旨在帮助高中英语教师快速创建和管理听说训练任务。

教师可以选择教材册次、单元、课文和课型，然后创建以下教学内容：

- 英音版听力训练
- 美音版听力训练
- 单词和句子跟读
- 影子跟读
- 课文复述
- 情景对话
- 图片描述
- 课堂讨论
- 口语作业
- 班级错误分析
- 学生训练进步记录

系统重点关注以下能力：

- 听力理解
- 发音清晰度
- 单词重音
- 句子重音
- 语调
- 节奏
- 连读和弱读
- 口语流利度
- 内容完成度
- 英音和美音的识别能力

系统不以“完全像母语者”为唯一目标，而是优先评价学生是否能够清晰、自然、有效地表达。

---

## 产品目标

### 教师目标

教师能够在 10 分钟内完成一节听说训练任务的创建、布置和发布。

### 学生目标

学生能够围绕教材内容完成：

1. 听音辨识
2. 句子跟读
3. 影子跟读
4. 关键词复述
5. 情景对话
6. 口语表达
7. 错误订正

### 教学目标

通过教师审核和 AI 辅助分析，形成以下教学闭环：

```text
教材单元
   ↓
听说任务设计
   ↓
学生练习与录音
   ↓
AI 初步反馈
   ↓
教师查看班级问题
   ↓
针对性补救训练
```

---

## 核心用户

### 教师

- 高中英语教师
- 英语备课组长
- 年级英语教研员
- 课后服务教师
- 英语培训机构教师

### 学生

首期暂不开放独立注册，学生由教师创建班级后加入训练。

### 管理员

负责：

- 用户管理
- 素材审核
- 音频资源管理
- 模型调用管理
- 系统运行监控

---

## 核心功能

## 1. 教材单元管理

教师可以创建或管理教学单元：

- 年级
- 教材册次
- Unit
- Lesson
- 课型
- 主题语境
- 教学目标
- 核心词汇
- 核心句型
- 语法重点
- 听说目标
- 写作或表达任务

教材内容应由学校、教师或平台通过合法方式录入或上传。

---

## 2. 双口音听力训练

每个训练任务可以配置：

- 英音
- 美音
- 英音与美音对比
- 慢速播放
- 正常速度播放
- 分句播放
- 单句循环
- 盲听模式
- 显示文本
- 隐藏文本
- 关键词提示

支持的基础操作：

- 播放
- 暂停
- 调整速度
- 调整音量
- 循环播放
- 切换英音/美音
- 查看原文
- 标记生词
- 记录听力结果

---

## 3. 跟读训练

跟读任务分为三个层次：

### 单词层

训练：

- 元音
- 辅音
- 词尾音
- 单词重音
- 易混淆音素

### 短语层

训练：

- 连读
- 弱读
- 失去爆破
- 意群
- 短语节奏

### 句子层

训练：

- 句子重音
- 升降调
- 停顿
- 语速
- 语气
- 表达重点

学生可以选择英音或美音作为跟读示范。

---

## 4. 影子跟读

影子跟读模式允许学生在示范音频播放后延迟跟读。

功能包括：

- 设置跟读延迟时间
- 显示目标文本
- 显示学生录音波形
- 逐句对比
- 多次录音
- 保留最佳录音
- 查看教师反馈
- 查看 AI 参考反馈

影子跟读重点评价：

- 语速
- 节奏
- 停顿
- 连贯性
- 句子重音
- 语调变化

---

## 5. 口语表达训练

教师可以布置以下任务：

- 30 秒关键词复述
- 60 秒图片描述
- 90 秒观点表达
- 角色扮演
- 情景对话
- 小组讨论
- 课文内容复述
- 单元主题表达
- 问题回答
- 高考相关口语任务

每个任务可以配置：

- 题目
- 参考词汇
- 参考句型
- 目标时长
- 评分标准
- 是否允许查看提示
- 提交次数
- 截止时间

---

## 6. 口语评测

系统提供 AI 辅助评价，但最终教学判断由教师完成。

### 评分维度

| 维度 | 说明 |
|---|---|
| 可理解度 | 听者能否容易理解 |
| 发音清晰度 | 元音、辅音和词尾是否清楚 |
| 单词重音 | 单词重音是否合理 |
| 句子重音 | 关键信息是否得到突出 |
| 语调 | 陈述、疑问、强调和态度是否合理 |
| 节奏 | 强读、弱读和停顿是否自然 |
| 流利度 | 是否频繁停顿、重复或卡顿 |
| 内容完成度 | 是否完成题目要求 |
| 口音模式 | 英音、美音或其他发音特征 |

### 默认评分权重

```text
可理解度：30%
内容完成度：25%
流利度：15%
重音与语调：15%
音素发音：10%
口音接近度：5%
```

口音接近度只作为参考指标，不作为核心评价标准。

---

## 7. 教师端班级分析

教师可以查看：

- 班级平均正确率
- 英音听力正确率
- 美音听力正确率
- 跟读完成率
- 口语任务提交率
- 学生平均流利度
- 学生常见发音错误
- 高频错误单词
- 高频错误句型
- 重音错误分布
- 语调问题分布
- 学生训练进步趋势

系统应将数据转换成教师可以直接使用的教学建议，例如：

```text
本班多数学生能够理解慢速美音材料，
但在正常速度英音材料中容易漏听非重读音节。

建议下一节课增加：
1. 弱读识别训练
2. 英音正常语速精听
3. 分句影子跟读
```

---

## MVP 范围

第一版只实现以下闭环：

### 教师端

- 注册和登录
- 创建班级
- 创建教学单元
- 创建听说训练任务
- 配置英音或美音
- 查看学生提交记录
- 查看基础班级统计
- 导出训练结果

### 学生端

- 加入班级
- 查看训练任务
- 播放示范音频
- 进行听力答题
- 使用麦克风录音
- 播放自己的录音
- 提交录音
- 查看基础反馈

### AI 功能

第一版只提供：

- 语音转文字
- 目标文本与识别文本对比
- 基础流利度分析
- 发音错误位置提示
- 关键词完成度分析
- 自动生成教师参考建议

### 第一版暂不实现

- 自动批改整篇作文
- 自动生成整本教材内容
- 学生公开社交
- 直播课程
- 完整题库商城
- 自动替代教师评分
- 对学生进行高风险等级判断
- 将学生录音公开给其他用户

---

## 典型使用流程

## 教师流程

```text
登录
  ↓
创建班级
  ↓
选择教材册次和单元
  ↓
创建听说训练
  ↓
选择英音、美音或双口音
  ↓
配置听力题和口语任务
  ↓
发布任务
  ↓
查看学生完成情况
  ↓
查看班级问题
  ↓
布置补救训练
```

## 学生流程

```text
加入班级
  ↓
查看任务
  ↓
听英音或美音材料
  ↓
完成理解题
  ↓
跟读或复述
  ↓
录音提交
  ↓
查看参考反馈
  ↓
重新练习
```

---

## 技术方案

### 客户端体系架构

本平台采用 **「教师端 Web 大屏/桌面管理」+「学生端 Android 移动 App 随时随地听说训练」+「后端与 AI 评测服务」** 的跨端协同架构：

1. **学生端（Android 手机应用 / Flutter）**：
   - 框架：**Flutter 3.x+ (Dart)** 跨平台原生渲染引擎（60/120fps 高刷流畅度）
   - 架构模式：严格分层的 **MVVM (Model-View-ViewModel) + Repository Pattern**
   - 音频播放：`just_audio` + `audio_session`（毫秒级 Seek，英音/美音实时无缝切换，0.8x/1.0x/1.2x 变速）
   - 麦克风录音与实时波形：`record`（AAC-LC 128kbps / 44.1kHz 高品质录音）+ 实时振幅采样流
   - 状态管理：`provider` 响应式依赖注入

2. **教师管理端（Web 全栈 / Next.js）**：
   - Next.js (App Router) + TypeScript
   - Tailwind CSS + shadcn/ui + Recharts (班级学情图表)
   - 负责：创建班级、选择人教版单元、配置听说作业、在线试听学生录音、查看班级多维错误诊断

3. **后端与数据层**：
   - Next.js Server Actions / Route Handlers
   - PostgreSQL + Prisma ORM
   - Supabase Auth & Storage (或 S3 私有对象存储)

4. **语音与 AI 评测服务**：
   - ASR 语音识别 (OpenAI Whisper / faster-whisper) 提取词级时间戳 (Word-level timestamps)
   - 文本对齐与 Levenshtein 算法比对（准确率、漏读、误读音标定位）
   - 大语言模型 (LLM) 负责课文复述要点匹配与个性化教学处方生成

### 音频能力 (Android 原生)

安卓客户端基于 Flutter 原生音频通道与系统 AudioRecord 交互：
- 动态申请 `android.permission.RECORD_AUDIO` 与 `MODIFY_AUDIO_SETTINGS` 运行时权限。
- 采用双轨波形比对器（上轨为示范标准原声波形，下轨为麦克风实时声音能量波形）。
- 影子跟读模式下内置毫秒级播放与录音启动延迟补偿计算。


### AI 服务

AI 服务分为以下几类：

1. 语音识别
2. 语音与文本对齐
3. 发音分析
4. 流利度分析
5. 口语反馈生成
6. 教学建议生成

AI 输出必须采用结构化 JSON，不允许直接返回不可解析的大段文本。

---

## 项目结构 (学生端 Android - Flutter 原生应用)

```text
highschool-english/
├── android/                         # Android 原生平台工程与构建配置
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml  # 麦克风录音权限与网络配置
│   │   │   └── kotlin/.../MainActivity.kt
│   │   └── build.gradle             # Android App Gradle 配置 (minSdk 21, compileSdk 34)
│   ├── build.gradle                 # 根 Gradle 依赖配置
│   └── settings.gradle
├── assets/                          # 本地静态音频与图片素材
│   ├── audio/                       # 课文与人教版双口音示范离线包
│   └── images/
├── lib/                             # Flutter Dart 核心代码 (MVVM 分层架构)
│   ├── data/                        # 数据访问层 (Repository 模式)
│   │   ├── repositories/
│   │   │   ├── assignment_repository.dart  # 听说任务数据仓库
│   │   │   └── practice_repository.dart    # 练习提交与 AI 评测仓库
│   │   └── services/
│   │       ├── audio_player_service.dart   # 双口音播放与 0.8x/1.0x/1.2x 调速服务
│   │       ├── audio_recorder_service.dart # 麦克风高品质录音与振幅流服务
│   │       └── mock_data_service.dart      # 人教版 Unit 1 示例单元与仿真 AI 诊断服务
│   ├── domain/                      # 业务领域实体模型层
│   │   └── models/
│   │       ├── accent_type.dart            # 英音 (RP) / 美音 (GA) 枚举
│   │       ├── assignment.dart             # 任务作业与类型模型 (精听/跟读/影子/复述)
│   │       ├── task_item.dart              # 听说训练单句、音标说明与关键词
│   │       └── speech_evaluation.dart      # 智能评测六维打分与逐词诊断模型
│   ├── ui/                          # 展示层 (Presentation - MVVM)
│   │   ├── core/                    # 共享主题、样式与通用控件
│   │   │   ├── theme/
│   │   │   │   └── app_theme.dart          # 现代教育墨青蓝主题 (Material 3)
│   │   │   └── widgets/
│   │   │       ├── accent_toggle_bar.dart  # 英音/美音即时切换开关
│   │   │       └── waveform_view.dart      # 示范原声 vs 学生录音双轨波形组件
│   │   └── features/                # 按业务特性垂直切分
│   │       ├── home/                # 首页看板与任务清单
│   │       │   ├── view_models/home_view_model.dart
│   │       │   └── views/home_screen.dart
│   │       ├── practice/            # 听说训练核心互动台
│   │       │   ├── view_models/practice_view_model.dart
│   │       │   └── views/practice_screen.dart
│   │       └── submission/          # 提交与 AI 诊断反馈
│   │           └── views/evaluation_sheet.dart # 词级诊断与针对性教学建议弹层
│   └── main.dart                    # 应用统一入口与全局 Provider 依赖注入
├── test/                            # 自动化单元测试
│   └── assignment_repository_test.dart
├── pubspec.yaml                     # Flutter 项目依赖与资产配置
└── README.md                        # 完整设计规格与技术文档
```

---

## 数据模型

### User

```text
id
name
email
role
created_at
updated_at
```

`role` 可选：

```text
teacher
student
admin
```

### Class

```text
id
name
teacher_id
grade
school_name
created_at
```

### StudentClass

```text
id
student_id
class_id
joined_at
```

### TextbookUnit

```text
id
grade
book_name
unit_number
unit_title
theme
learning_objectives
created_by
created_at
```

### Assignment

```text
id
unit_id
class_id
title
description
task_type
accent_mode
target_duration
deadline
status
created_by
created_at
```

`task_type`：

```text
listening
shadowing
reading_aloud
retelling
role_play
picture_description
free_speaking
```

`accent_mode`：

```text
british
american
both
```

### AudioMaterial

```text
id
assignment_id
accent
audio_url
transcript
slow_audio_url
normal_audio_url
created_at
```

### Submission

```text
id
assignment_id
student_id
audio_url
transcript
duration
status
submitted_at
```

### SpeechEvaluation

```text
id
submission_id
intelligibility_score
pronunciation_score
stress_score
intonation_score
fluency_score
content_score
accent_score
feedback
error_details
created_at
```

---

## 本地开发

### 环境要求

- Node.js 20+
- npm 10+ 或 pnpm 9+
- Git
- Supabase 项目
- 可用的语音识别服务 API
- 可用的大模型 API

### 安装项目

```bash
git clone https://github.com/your-org/high-school-english-speaking.git

cd high-school-english-speaking

npm install
```

### 配置环境变量

复制环境变量模板：

```bash
cp .env.example .env.local
```

填写 `.env.local` 后启动开发服务器：

```bash
npm run dev
```

打开：

```text
http://localhost:3000
```

### 常用命令

```bash
npm run dev
npm run build
npm run start
npm run lint
npm run type-check
npm run test
npm run test:e2e
```

---

## 环境变量

`.env.example`：

```env
# Application
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# AI Provider
AI_API_KEY=
AI_BASE_URL=
AI_MODEL=

# Speech-to-Text Provider
SPEECH_API_KEY=
SPEECH_API_BASE_URL=
SPEECH_MODEL=

# Object Storage
STORAGE_BUCKET_AUDIO=student-recordings

# Feature Flags
ENABLE_AI_FEEDBACK=false
ENABLE_ACCENT_ANALYSIS=false
```

注意：

- `SUPABASE_SERVICE_ROLE_KEY` 只能在服务端使用。
- 不得将私钥提交到 GitHub。
- `.env.local` 必须加入 `.gitignore`。
- 学生录音文件不能通过公开 URL 长期暴露。

---

## 开发规范

## 分支规范

```text
main        生产稳定分支
develop     集成开发分支
feature/*   新功能
fix/*       问题修复
refactor/*  重构
docs/*      文档修改
```

示例：

```bash
git checkout -b feature/audio-recorder
```

## 提交信息规范

推荐使用 Conventional Commits：

```text
feat: add audio recorder
fix: fix assignment submission bug
docs: update README
refactor: improve speech scoring service
test: add recorder tests
```

## 代码原则

- 所有表单必须进行前端和后端双重校验。
- 所有 AI 输出必须进行 schema 校验。
- 所有分数必须保留原始分析依据。
- 不允许在前端直接暴露服务端密钥。
- 不允许将学生姓名直接发送给 AI 服务。
- 组件优先保持单一职责。
- 复杂业务逻辑放入 `lib/`，不要全部写在页面组件中。
- 重要计算必须配套单元测试。
- 语音评分逻辑必须保留可解释字段。

---

## 语音功能设计

### 录音流程

```text
请求麦克风权限
  ↓
检测浏览器是否支持 MediaRecorder
  ↓
开始录音
  ↓
实时显示录音状态
  ↓
停止录音
  ↓
生成音频 Blob
  ↓
本地试听
  ↓
上传对象存储
  ↓
调用语音识别服务
  ↓
生成参考反馈
```

### 录音状态

```text
idle
requesting_permission
recording
paused
stopped
uploading
processing
completed
error
```

### 录音要求

- 默认单次录音不超过 3 分钟。
- 显示录音时长。
- 显示当前麦克风状态。
- 允许重新录音。
- 允许学生在提交前试听。
- 录音失败时提供明确提示。
- 浏览器不支持录音时提供替代方案。
- 训练结束后及时释放麦克风资源。

### 语音反馈 JSON 示例

```json
{
  "overallScore": 78,
  "intelligibilityScore": 84,
  "pronunciationScore": 76,
  "stressScore": 70,
  "intonationScore": 74,
  "fluencyScore": 82,
  "contentScore": 86,
  "accentMode": "american",
  "recognizedText": "I would like to talk about climate change.",
  "targetText": "I would like to talk about climate change.",
  "errors": [
    {
      "word": "climate",
      "type": "stress",
      "message": "The first syllable should receive stronger stress.",
      "severity": "medium"
    }
  ],
  "suggestions": [
    "Practice the sentence in three short chunks.",
    "Stress the key words: like, talk, climate change.",
    "Record again at a slightly slower speed."
  ]
}
```

---

## AI 功能设计

### AI 使用原则

- AI 生成内容必须经过教师审核。
- AI 评分仅作为辅助，不直接替代教师成绩。
- AI 必须说明评价依据。
- AI 不得输出侮辱性或标签化描述。
- AI 不得将学生定义为“没有语言天赋”或类似结论。
- AI 反馈应具体到单词、句子、重音、停顿或表达内容。
- 口音差异不能简单判定为错误。
- 优先评价可理解度和表达完成度。

### 教案生成输出

```json
{
  "lessonObjectives": [],
  "keyVocabulary": [],
  "pronunciationFocus": [],
  "listeningTasks": [],
  "speakingTasks": [],
  "differentiatedTasks": {
    "basic": [],
    "intermediate": [],
    "advanced": []
  },
  "homework": [],
  "teacherNotes": []
}
```

### 教师确认机制

以下内容必须由教师确认后才能发布：

- AI 生成的听力文本
- AI 生成的口语题目
- AI 生成的标准答案
- AI 生成的评分标准
- AI 生成的教学反馈
- AI 生成的教材相关内容

---

## 隐私、版权与安全

### 学生隐私

系统应尽量避免收集不必要的个人信息。

首期建议仅保存：

- 学生显示名称或编号
- 班级编号
- 训练记录
- 录音文件
- 评分结果

不建议首期收集：

- 身份证号码
- 家庭住址
- 手机号码
- 人脸信息
- 精确地理位置
- 与教学无关的个人资料

发送给 AI 服务前，应删除或替换学生姓名等个人信息。

### 音频安全

- 学生录音默认仅本人和任课教师可访问。
- 使用带权限控制的对象存储。
- 音频 URL 应设置有效期。
- 教师删除学生数据后，同时删除对应音频。
- 不得默认公开学生录音。
- 不得将学生录音用于模型训练，除非取得明确授权。

### 教材版权

- 不直接公开传播完整教材内容。
- 平台内教材资源必须具备合法来源。
- 教师上传的资源应由上传者确认拥有使用权。
- 公共演示项目使用自制或授权示例材料。
- README、测试数据和 Demo 不放入完整教材文章。

---

## 开发路线图

## Phase 1：基础原型

- [ ] 创建项目脚手架
- [ ] 完成教师登录
- [ ] 创建班级
- [ ] 创建教材单元
- [ ] 创建听说任务
- [ ] 音频播放
- [ ] 浏览器录音
- [ ] 本地播放录音
- [ ] 学生提交录音

## Phase 2：MVP

- [ ] Supabase 数据库接入
- [ ] 学生加入班级
- [ ] 教师发布作业
- [ ] 英音/美音模式选择
- [ ] 听力选择题
- [ ] 跟读训练
- [ ] 复述训练
- [ ] 语音转文字
- [ ] 基础流利度分析
- [ ] 教师查看提交记录

## Phase 3：AI 辅助分析

- [ ] 目标文本与识别文本对比
- [ ] 关键词完成度分析
- [ ] 停顿和语速分析
- [ ] 重音提示
- [ ] 语调提示
- [ ] 发音错误提示
- [ ] 教师反馈模板
- [ ] 班级共性问题分析

## Phase 4：教学产品化

- [ ] 教案生成
- [ ] 分层练习生成
- [ ] 单元训练包
- [ ] 训练数据导出
- [ ] Word/PDF 导出
- [ ] 年级和备课组管理
- [ ] 多学校权限体系
- [ ] 资源审核流程

---

## 验收标准

### 教师端

- 教师能够成功创建班级。
- 教师能够创建一个单元和一个听说任务。
- 教师能够配置英音、美音或双口音模式。
- 教师能够发布任务。
- 教师能够查看学生的提交记录。
- 教师能够查看班级完成率和平均成绩。

### 学生端

- 学生能够加入班级。
- 学生能够播放示范音频。
- 学生能够完成听力题。
- 学生能够授权麦克风。
- 学生能够录音、暂停、停止和试听。
- 学生能够提交录音。
- 学生能够重新录音。
- 学生能够查看基础反馈。

### 音频端

- 主流桌面浏览器能够正常录音。
- 移动端浏览器能够正常录音。
- 麦克风权限拒绝时有明确提示。
- 录音失败时不会导致页面崩溃。
- 音频上传失败时可以重新上传。
- 音频播放、暂停和进度控制正常。

### AI 端

- AI 服务失败时系统仍允许教师查看原始录音。
- AI 返回格式错误时系统能够捕获异常。
- AI 反馈不能阻塞教师查看提交记录。
- 每个分数都能对应到具体分析字段。
- AI 结果明确标记为“参考反馈”。

---

## 项目原则

本项目坚持以下原则：

1. 教师主导，AI 辅助。
2. 先解决教学问题，再增加 AI 功能。
3. 优先提高可理解度，而不是追求口音模仿。
4. 英音和美音并列呈现，不进行高低评价。
5. 所有自动评分都应可解释。
6. 所有教材资源都必须关注版权。
7. 所有学生数据都必须最小化收集。
8. 先完成一个稳定的 MVP，再扩展复杂功能。

---

## 许可证

当前项目暂未确定开源许可证。

如果项目仅供个人或学校内部使用，可暂时标记为：

```text
All Rights Reserved
```

如果未来计划开源，再根据代码、音频、教材资源和第三方依赖的授权情况选择合适的许可证。

---

## 当前开发任务

第一步建议实现以下页面：

1. 教师登录页
2. 教师控制台
3. 班级列表页
4. 听说训练创建页
5. 学生训练页
6. 音频播放器
7. 浏览器录音组件
8. 录音提交页
9. 教师查看结果页

首个可运行 Demo 的目标：

> 教师创建一条“英音/美音跟读任务”，学生打开任务、播放示范音频、完成录音并提交，教师可以在后台播放学生录音并查看基础统计。
