import 'package:flutter/material.dart';

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        title: const Text(
          'App Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ======================================================
          // APP LOGO / NAME
          // ======================================================

          Center(
            child: Column(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    size: 55,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Stryve',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Your fitness journey starts here.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // ======================================================
          // ABOUT
          // ======================================================

          _buildSectionTitle(
            context,
            'About Stryve',
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Stryve is a fitness companion designed to '
                'help users plan workouts, understand exercises, '
                'track their fitness journey, and receive '
                'personalized fitness guidance.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: colors.onSurface,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // FEATURES
          // ======================================================

          _buildSectionTitle(
            context,
            'Features',
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                _buildFeatureTile(
                  context,
                  icon: Icons.calendar_month,
                  title: 'Workout Planning',
                  description:
                      'Create and manage your weekly workout schedule.',
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                _buildFeatureTile(
                  context,
                  icon: Icons.fitness_center,
                  title: 'Exercise Guidance',
                  description:
                      'Learn about exercises and perform your workouts.',
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                _buildFeatureTile(
                  context,
                  icon: Icons.restaurant,
                  title: 'Food Recommendations',
                  description:
                      'Receive fitness-focused food guidance.',
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                _buildFeatureTile(
                  context,
                  icon: Icons.smart_toy_outlined,
                  title: 'AI Assistant',
                  description:
                      'Get fitness-related guidance through the AI assistant.',
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                _buildFeatureTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Workout Reminders',
                  description:
                      'Receive reminders for your scheduled workouts.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // APP DETAILS
          // ======================================================

          _buildSectionTitle(
            context,
            'App Details',
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.apps,
                    color: colors.primary,
                  ),

                  title: Text(
                    'Application',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),

                  subtitle: Text(
                    'Stryve',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: colors.primary,
                  ),

                  title: Text(
                    'Version',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),

                  subtitle: Text(
                    '1.0.1',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SAFETY
          // ======================================================

          _buildSectionTitle(
            context,
            'Safety',
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.health_and_safety_outlined,
                    color: colors.primary,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Stryve provides general fitness and '
                      'wellness guidance. It is not a replacement '
                      'for professional medical advice, diagnosis, '
                      'or treatment.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ======================================================
          // FOOTER
          // ======================================================

          Center(
            child: Text(
              'Stryve • Your Fitness Journey',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: colors.onSurface,
      ),
    );
  }

  // ============================================================
  // FEATURE TILE
  // ============================================================

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      leading: Icon(
        icon,
        color: colors.primary,
        size: 28,
      ),

      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
      ),

      subtitle: Text(
        description,
        style: TextStyle(
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}