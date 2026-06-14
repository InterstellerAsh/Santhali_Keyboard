import 'package:flutter/material.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';

class KeyboardThemeData {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color keySurface;
  final Color onSurface;
  final Color onPrimary;
  final Color accentDivider;
  final Color actionKeySurface;
  
  // Premium Gradients
  final Gradient primaryGradient;
  final Gradient backgroundGradient;
  final Gradient secondaryGradient;
  final Gradient keyGradient;

  const KeyboardThemeData({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.keySurface,
    required this.onSurface,
    required this.onPrimary,
    required this.accentDivider,
    required this.actionKeySurface,
    required this.primaryGradient,
    required this.backgroundGradient,
    required this.secondaryGradient,
    required this.keyGradient,
  });

  static KeyboardThemeData getTheme(KeyboardSettings settings) {
    switch (settings.themeMode) {
      case 'slate':
        return const KeyboardThemeData(
          primary: Color(0xFF303030),
          secondary: Color(0xFF89726C),
          background: Color(0xFFF3F0F0),
          surface: Color(0xFFE4E2E1),
          keySurface: Color(0xFFDCD9D9),
          onSurface: Color(0xFF1B1C1C),
          onPrimary: Colors.white,
          accentDivider: Color(0xFF89726C),
          actionKeySurface: Color(0xFFDCD9D9),
          primaryGradient: LinearGradient(
            colors: [Color(0xFF1B1C1C), Color(0xFF3C3E3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundGradient: LinearGradient(
            colors: [Color(0xFFF3F0F0), Color(0xFFE5E2E2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          secondaryGradient: LinearGradient(
            colors: [Color(0xFF89726C), Color(0xFFA58D87)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          keyGradient: LinearGradient(
            colors: [Color(0xFFECEAEA), Color(0xFFDCD9D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'gold':
        return const KeyboardThemeData(
          primary: Color(0xFF7F735F),
          secondary: Color(0xFF221B0C),
          background: Color(0xFFF0E1C8),
          surface: Color(0xFFD3C5AD),
          keySurface: Color(0xFFEAE7E7),
          onSurface: Color(0xFF221B0C),
          onPrimary: Colors.white,
          accentDivider: Color(0xFF7F735F),
          actionKeySurface: Color(0xFFEAE7E7),
          primaryGradient: LinearGradient(
            colors: [Color(0xFF7F735F), Color(0xFF9E8F77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundGradient: LinearGradient(
            colors: [Color(0xFFF0E1C8), Color(0xFFE5D5BC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          secondaryGradient: LinearGradient(
            colors: [Color(0xFF221B0C), Color(0xFF3D321A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          keyGradient: LinearGradient(
            colors: [Color(0xFFFAF9F7), Color(0xFFEAE7E7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'custom':
        final primaryColor = settings.customPrimaryColor;
        final secondaryColor = settings.customSecondaryColor;
        final bgColor = settings.customBackgroundColor;
        return KeyboardThemeData(
          primary: primaryColor,
          secondary: secondaryColor,
          background: bgColor,
          surface: bgColor.withOpacity(0.9),
          keySurface: secondaryColor.withOpacity(0.15),
          onSurface: Colors.black87,
          onPrimary: Colors.white,
          accentDivider: primaryColor,
          actionKeySurface: secondaryColor.withOpacity(0.25),
          primaryGradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundGradient: LinearGradient(
            colors: [bgColor, bgColor.withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          secondaryGradient: LinearGradient(
            colors: [secondaryColor, secondaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          keyGradient: LinearGradient(
            colors: [Colors.white, bgColor.withOpacity(0.95)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'kherwal':
      default:
        return const KeyboardThemeData(
          primary: Color(0xFF994126), // Terracotta Earth
          secondary: Color(0xFF376757), // Forest Green
          background: Color(0xFFFCF9F8), // Warm Cream
          surface: Color(0xFFF5F0E6), // Light Sand
          keySurface: Color(0xFFF0EDED), // Key plate
          onSurface: Color(0xFF1B1C1C), // Charcoal
          onPrimary: Colors.white,
          accentDivider: Color(0xFF89726C),
          actionKeySurface: Color(0xFFE4E2E1),
          primaryGradient: LinearGradient(
            colors: [Color(0xFF994126), Color(0xFFC15C3E)], // Vibrant terracotta gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundGradient: LinearGradient(
            colors: [Color(0xFFFCF9F8), Color(0xFFF7F2EF)], // Subtle warmth
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          secondaryGradient: LinearGradient(
            colors: [Color(0xFF376757), Color(0xFF4C8C77)], // Forest green gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          keyGradient: LinearGradient(
            colors: [Color(0xFFFCFCFB), Color(0xFFF0EDED)], // Tactile white to sand
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
    }
  }
}
