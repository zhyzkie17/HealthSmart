import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme(Color accentColor) {
    const background = Color(0xFFF8FBF8);
    const surface = Colors.white;
    const textPrimary = Color(0xFF173B32);
    const textSecondary = Color(0xFF49665D);

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      // ========================================================
      // COLOR SCHEME
      // ========================================================

      colorScheme: ColorScheme.light(
        // Accent is used for interactive Material components.
        primary: accentColor,
        onPrimary: Colors.white,

        // KEEP CONTAINERS NEUTRAL.
        primaryContainer: Color(0xFFE8EEE9),
        onPrimaryContainer: textPrimary,

        secondary: accentColor,
        onSecondary: Colors.white,

        secondaryContainer: Color(0xFFE8EEE9),
        onSecondaryContainer: textPrimary,

        surface: surface,
        onSurface: textPrimary,

        surfaceContainerHighest: Color(0xFFEFF3F0),
        onSurfaceVariant: textSecondary,

        outline: Color(0xFFB8C4BD),
        outlineVariant: Color(0xFFD8E0DB),

        error: Color(0xFFBA1A1A),
        onError: Colors.white,
      ),

      // ========================================================
      // MAIN BACKGROUND
      // ========================================================

      scaffoldBackgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: const CardThemeData(
        color: surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // ELEVATED BUTTONS
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 2,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ========================================================
      // FILLED BUTTONS
      // ========================================================

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
      ),

      // ========================================================
      // OUTLINED BUTTONS
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(
            color: accentColor,
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTONS
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
        ),
      ),

      // ========================================================
      // ICON BUTTONS
      // ========================================================

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: accentColor,
        ),
      ),

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD8E0DB),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD8E0DB),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),

        labelStyle: const TextStyle(
          color: textSecondary,
        ),

        floatingLabelStyle: TextStyle(
          color: accentColor,
        ),
      ),

      // ========================================================
      // CHECKBOX
      // ========================================================

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return Colors.transparent;
          },
        ),
      ),

      // ========================================================
      // RADIO
      // ========================================================

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return textSecondary;
          },
        ),
      ),

      // ========================================================
      // SWITCH
      // ========================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return Colors.grey;
          },
        ),

        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor.withValues(alpha: 0.35);
            }

            return Colors.grey.withValues(alpha: 0.25);
          },
        ),
      ),

      // ========================================================
      // PROGRESS INDICATOR
      // ========================================================

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
      ),

      // ========================================================
      // NAVIGATION BAR
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,

        // Neutral indicator.
        indicatorColor: Color(0xFFE3E9E5),

        labelTextStyle:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              );
            }

            return const TextStyle(
              color: textSecondary,
            );
          },
        ),

        iconTheme:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: accentColor,
              );
            }

            return const IconThemeData(
              color: textSecondary,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme(Color accentColor) {
    const background = Color(0xFF181A1B);
    const surface = Color(0xFF242728);

    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFB8C4BD);

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // ========================================================
      // COLOR SCHEME
      // ========================================================

      colorScheme: ColorScheme.dark(
        primary: accentColor,
        onPrimary: Colors.white,

        // KEEP CONTAINERS NEUTRAL.
        primaryContainer: Color(0xFF303533),
        onPrimaryContainer: textPrimary,

        secondary: accentColor,
        onSecondary: Colors.white,

        secondaryContainer: Color(0xFF303533),
        onSecondaryContainer: textPrimary,

        surface: surface,
        onSurface: textPrimary,

        surfaceContainerHighest: Color(0xFF303333),
        onSurfaceVariant: textSecondary,

        outline: Color(0xFF68736D),
        outlineVariant: Color(0xFF444B48),

        error: Color(0xFFFFB4AB),
        onError: Colors.black,
      ),

      // ========================================================
      // MAIN BACKGROUND
      // ========================================================

      scaffoldBackgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: const CardThemeData(
        color: surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // ELEVATED BUTTONS
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 2,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ========================================================
      // FILLED BUTTONS
      // ========================================================

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
      ),

      // ========================================================
      // OUTLINED BUTTONS
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(
            color: accentColor,
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTONS
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
        ),
      ),

      // ========================================================
      // ICON BUTTONS
      // ========================================================

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: accentColor,
        ),
      ),

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF444B48),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF444B48),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),

        labelStyle: const TextStyle(
          color: textSecondary,
        ),

        floatingLabelStyle: TextStyle(
          color: accentColor,
        ),
      ),

      // ========================================================
      // CHECKBOX
      // ========================================================

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return Colors.transparent;
          },
        ),
      ),

      // ========================================================
      // RADIO
      // ========================================================

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return textSecondary;
          },
        ),
      ),

      // ========================================================
      // SWITCH
      // ========================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }

            return Colors.grey;
          },
        ),

        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor.withValues(alpha: 0.35);
            }

            return Colors.grey.withValues(alpha: 0.25);
          },
        ),
      ),

      // ========================================================
      // PROGRESS INDICATOR
      // ========================================================

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
      ),

      // ========================================================
      // NAVIGATION BAR
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,

        // Neutral indicator.
        indicatorColor: Color(0xFF303533),

        labelTextStyle:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              );
            }

            return const TextStyle(
              color: textSecondary,
            );
          },
        ),

        iconTheme:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: accentColor,
              );
            }

            return const IconThemeData(
              color: textSecondary,
            );
          },
        ),
      ),
    );
  }
}