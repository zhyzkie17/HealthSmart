import 'package:flutter/material.dart';
import 'appearance_screen.dart';
import '../theme/theme_control.dart';
import 'app_information_screen.dart';
import 'workout_settings_screen.dart';

class AppSettingsScreen extends StatelessWidget {
  final ThemeController themeController;

  const AppSettingsScreen({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'App Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // =========================
          // GENERAL
          // =========================
          Text(
            'General',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                // =========================
                // APPEARANCE
                // =========================
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppearanceScreen(
                          themeController: themeController,
                        ),
                      ),
                    );
                  },

                  leading: Icon(
                    Icons.dark_mode_outlined,
                    color: primaryColor,
                  ),

                  title: Text(
                    'Appearance',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),

                  subtitle: Text(
                    'Customize how the app looks',
                    style: TextStyle(
                      color: secondaryTextColor,
                    ),
                  ),

                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: secondaryTextColor,
                  ),
                ),

                const Divider(height: 1),

                // =========================
                // WORKOUT SETTINGS
                // =========================
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutSettingsScreen(),
              ),
            );
          },

          leading: Icon(
            Icons.fitness_center,
            color: Theme.of(context).colorScheme.primary,
          ),

          title: Text(
            'Workout Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          subtitle: Text(
            'Customize your workout experience',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // =========================
          // APP INFORMATION
          // =========================
          Text(
            'App Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AppInformationScreen(),
                  ),
                );
              },

              leading: Icon(
                Icons.info_outline,
                color: primaryColor,
              ),

              title: Text(
                'About Stryve',
                style: TextStyle(
                  color: textColor,
                ),
              ),

              subtitle: Text(
                'App information and version',
                style: TextStyle(
                  color: secondaryTextColor,
                ),
              ),

              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}