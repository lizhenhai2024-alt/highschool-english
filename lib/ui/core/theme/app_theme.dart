import 'package:flutter/material.dart';

class AppTheme {
  // 品牌主色系：人教版教育墨青蓝与活泼薄荷绿搭配
  static const Color primaryBlue = Color(0xFF1E5BB0);
  static const Color secondaryCyan = Color(0xFF00A896);
  static const Color accentOrange = Color(0xFFFF7A00);
  static const Color accentPurple = Color(0xFF6C5CE7);

  // 背景色与表面色
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceCard = Colors.white;
  static const Color textMain = Color(0xFF1A2138);
  static const Color textSecondary = Color(0xFF6B7280);

  // 口音专属标识色
  static const Color ukAccentColor = Color(0xFFC8102E); // 英国红
  static const Color usAccentColor = Color(0xFF0C2340); // 美国海军蓝

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryCyan,
        surface: surfaceCard,
        background: backgroundLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textMain,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
