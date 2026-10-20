import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Theme chính của app Wake Up.
/// Dark theme, nền đen, màu nhấn cam, bám giao diện app Đồng hồ của iPhone.
class AppTheme {
  AppTheme._();

  // ── Màu sắc ──
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceDarkElevated = Color(0xFF2C2C2E);
  static const Color separatorColor = Color(0xFF38383A);
  static const Color labelPrimary = Color(0xFFFFFFFF);
  static const Color labelSecondary = Color(0xFF98989D);
  static const Color labelTertiary = Color(0xFF636366);
  static const Color destructiveRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF30D158);

  // ── Typography ──
  /// Kiểu chữ số lớn mảnh cho hiển thị giờ (giống iPhone Clock app)
  static const TextStyle timeDisplayLarge = TextStyle(
    fontSize: 86,
    fontWeight: FontWeight.w100,
    letterSpacing: -2,
    color: labelPrimary,
    height: 1.0,
  );

  static const TextStyle timeDisplayMedium = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w200,
    letterSpacing: -1,
    color: labelPrimary,
    height: 1.0,
  );

  static const TextStyle timeDisplaySmall = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w200,
    letterSpacing: -0.5,
    color: labelPrimary,
    height: 1.2,
  );

  // ── CupertinoThemeData ──
  static CupertinoThemeData get cupertinoTheme => const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: accentOrange,
    scaffoldBackgroundColor: backgroundBlack,
    barBackgroundColor: Color(0xE6000000), // Thanh bar nền đen mờ
    textTheme: CupertinoTextThemeData(
      primaryColor: accentOrange,
      textStyle: TextStyle(
        color: labelPrimary,
        fontSize: 17,
      ),
      navTitleTextStyle: TextStyle(
        color: labelPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: labelPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  // ── ThemeData (cho các widget Material cần thiết) ──
  static ThemeData get materialTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundBlack,
    colorScheme: const ColorScheme.dark(
      primary: accentOrange,
      secondary: accentOrange,
      surface: surfaceDark,
      error: destructiveRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundBlack,
      foregroundColor: labelPrimary,
      elevation: 0,
    ),
  );
}
