import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  Color accentColor = const Color(0xFF43A047);

  // Used by main.dart to wait until saved settings are loaded.
  late final Future<void> ready;

  ThemeController() {
    ready = _loadSettings();
  }

  // ============================================================
  // LOAD SAVED SETTINGS
  // ============================================================

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // ------------------------------------------------------------
    // LOAD THEME
    // ------------------------------------------------------------

    final savedTheme = prefs.getString('themeMode');

    if (savedTheme != null) {
      switch (savedTheme) {
        case 'Light':
          themeMode = ThemeMode.light;
          break;

        case 'Dark':
          themeMode = ThemeMode.dark;
          break;

        case 'System':
          themeMode = ThemeMode.system;
          break;
      }
    }

    // ------------------------------------------------------------
    // LOAD ACCENT COLOR
    // ------------------------------------------------------------

    final savedColor = prefs.getInt('accentColor');

    if (savedColor != null) {
      accentColor = Color(savedColor);
    }

    notifyListeners();
  }

  // ============================================================
  // CHANGE AND SAVE THEME
  // ============================================================

  Future<void> setTheme(String theme) async {
    switch (theme) {
      case 'Light':
        themeMode = ThemeMode.light;
        break;

      case 'Dark':
        themeMode = ThemeMode.dark;
        break;

      case 'System':
        themeMode = ThemeMode.system;
        break;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('themeMode', theme);

    notifyListeners();
  }

  // ============================================================
  // CHANGE AND SAVE ACCENT COLOR
  // ============================================================

  Future<void> setAccentColor(Color color) async {
    accentColor = color;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'accentColor',
      color.toARGB32(),
    );

    notifyListeners();
  }
}