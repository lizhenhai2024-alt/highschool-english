/// 口音类型定义：英音 (British RP) 与 美音 (General American)
enum AccentType {
  british,
  american,
  both;

  String get displayName {
    switch (this) {
      case AccentType.british:
        return '英音 (RP)';
      case AccentType.american:
        return '美音 (GA)';
      case AccentType.both:
        return '双口音对照';
    }
  }

  String get flagEmoji {
    switch (this) {
      case AccentType.british:
        return '🇬🇧';
      case AccentType.american:
        return '🇺🇸';
      case AccentType.both:
        return '🌐';
    }
  }

  String get code {
    switch (this) {
      case AccentType.british:
        return 'uk';
      case AccentType.american:
        return 'us';
      case AccentType.both:
        return 'both';
    }
  }

  static AccentType fromString(String val) {
    switch (val.toLowerCase()) {
      case 'british':
      case 'uk':
        return AccentType.british;
      case 'american':
      case 'us':
        return AccentType.american;
      default:
        return AccentType.both;
    }
  }
}
