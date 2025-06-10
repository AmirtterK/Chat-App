import 'package:chat_app/services/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = darkMode;
  ThemeData get themeData => _theme;
  bool get isDarkMode => _theme == darkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await getTheme('isDarkMode') ?? true;
    _theme = isDark ? darkMode : lightMode;
    notifyListeners();
  }

  set themeData(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  void toggleTheme() async {
    themeData = isDarkMode ? lightMode : darkMode;
    saveTheme('isDarkMode', isDarkMode);
  }

  Future<void> saveTheme(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> getTheme(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
