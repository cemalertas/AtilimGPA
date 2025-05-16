import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language;

  LanguageProvider(String initialLanguage) : _language = initialLanguage;

  String get language => _language;

  Future<void> setLanguage(String language) async {
    if (_language == language) return;

    _language = language;
    notifyListeners();

    // Tercihi kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}