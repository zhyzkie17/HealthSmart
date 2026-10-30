import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../theme/theme_control.dart';

class WelcomeScreen extends StatelessWidget {
  final ThemeController themeController;

  const WelcomeScreen({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // User-selected accent color.
    // This is used ONLY for icons.
    final accentColor = themeController.accentColor;

    return Scaffold(
      // ============================================================
      // THEME BACKGROUND
      // ============================================================

      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            children: [
              const SizedBox(height: 35),

              // ====================================================
              // APP NAME
              // ====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 30,

                    // ACCENT COLOR → ICON ONLY
                    color: accentColor,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    'Stryve',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ====================================================
              // MAIN FITNESS ICON
              // ====================================================

              Container(
                width: 190,
                height: 190,

                decoration: BoxDecoration(
                  // Uses the normal theme surface.
                  // Accent color does NOT control this.
                  color: colors.surfaceContainerHighest,

                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: theme.brightness == Brightness.dark
                            ? 0.25
                            : 0.08,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),

                child: Icon(
                  Icons.directions_run,
                  size: 100,

                  // ACCENT COLOR → ICON ONLY
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 45),

              // ====================================================
              // MAIN HEADING
              // ====================================================

              Text(
                'Start Your\nFitness Journey',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 36,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 18),

              // ====================================================
              // DESCRIPTION
              // ====================================================

              Text(
                'Move your body, build healthy habits,\nand enjoy your journey. 🌱',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 35),

// ============================================================
// START BUTTON
// ============================================================

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainNavigation(
                        themeController: themeController,
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  // ACCENT COLOR → BUTTON
                  backgroundColor: accentColor,

                  // White text and icon for contrast
                  foregroundColor: Colors.white,

                  elevation: 5,

                  // ACCENT COLOR → BUTTON SHADOW
                  shadowColor: accentColor.withValues(alpha: 0.25),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      'START MY JOURNEY',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

              const SizedBox(height: 18),

              // ====================================================
              // MOTIVATIONAL MESSAGE
              // ====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.wb_sunny,
                    size: 18,

                    // ACCENT COLOR → ICON ONLY
                    color: accentColor,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    'Your journey starts today.',

                    style: TextStyle(
                      fontSize: 14,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}