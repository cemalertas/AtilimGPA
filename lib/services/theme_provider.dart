import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider(ThemeMode initialTheme) : _themeMode = initialTheme;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;
    notifyListeners();

    // Tercihi kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', themeMode == ThemeMode.dark);
  }

  Future<void> toggleTheme() async {
    final newThemeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newThemeMode);
  }
}