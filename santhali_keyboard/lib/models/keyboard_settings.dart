import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyboardSettings extends ChangeNotifier {
  static const String _keyHaptic = 'haptic_feedback';
  static const String _keySound = 'sound_keypress';
  static const String _keyAutoCorrect = 'auto_correct';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyCustomPrimary = 'custom_primary';
  static const String _keyCustomSecondary = 'custom_secondary';
  static const String _keyCustomBg = 'custom_background';
  static const String _keyHeight = 'keyboard_height';

  bool _hapticFeedback = true;
  bool _soundOnKeypress = false;
  bool _autoCorrect = true;
  String _themeMode = 'kherwal'; // 'kherwal', 'slate', 'gold', 'custom'
  Color _customPrimaryColor = const Color.fromARGB(255, 142, 46, 17);
  Color _customSecondaryColor = const Color(0xFF376757);
  Color _customBackgroundColor = const Color(0xFFFCF9F8);
  double _keyboardHeight = 280.0;

  bool get hapticFeedback => _hapticFeedback;
  bool get soundOnKeypress => _soundOnKeypress;
  bool get autoCorrect => _autoCorrect;
  String get themeMode => _themeMode;
  Color get customPrimaryColor => _customPrimaryColor;
  Color get customSecondaryColor => _customSecondaryColor;
  Color get customBackgroundColor => _customBackgroundColor;
  double get keyboardHeight => _keyboardHeight;

  KeyboardSettings() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hapticFeedback = prefs.getBool(_keyHaptic) ?? true;
      _soundOnKeypress = prefs.getBool(_keySound) ?? false;
      _autoCorrect = prefs.getBool(_keyAutoCorrect) ?? true;
      _themeMode = prefs.getString(_keyThemeMode) ?? 'kherwal';
      _keyboardHeight = prefs.getDouble(_keyHeight) ?? 280.0;

      final prim = prefs.getInt(_keyCustomPrimary);
      if (prim != null) _customPrimaryColor = Color(prim);

      final sec = prefs.getInt(_keyCustomSecondary);
      if (sec != null) _customSecondaryColor = Color(sec);

      final bg = prefs.getInt(_keyCustomBg);
      if (bg != null) _customBackgroundColor = Color(bg);

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptic, value);
  }

  Future<void> setSoundOnKeypress(bool value) async {
    _soundOnKeypress = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySound, value);
  }

  Future<void> setAutoCorrect(bool value) async {
    _autoCorrect = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoCorrect, value);
  }

  Future<void> setThemeMode(String value) async {
    _themeMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, value);
  }

  Future<void> setKeyboardHeight(double value) async {
    _keyboardHeight = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyHeight, value);
  }

  Future<void> setCustomColors({
    Color? primary,
    Color? secondary,
    Color? bg,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (primary != null) {
      _customPrimaryColor = primary;
      await prefs.setInt(_keyCustomPrimary, primary.value);
    }
    if (secondary != null) {
      _customSecondaryColor = secondary;
      await prefs.setInt(_keyCustomSecondary, secondary.value);
    }
    if (bg != null) {
      _customBackgroundColor = bg;
      await prefs.setInt(_keyCustomBg, bg.value);
    }
    notifyListeners();
  }
}
