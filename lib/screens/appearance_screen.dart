import 'package:flutter/material.dart';
import '../theme/theme_control.dart';

class AppearanceScreen extends StatefulWidget {
  final ThemeController themeController;

  const AppearanceScreen({
    super.key,
    required this.themeController,
  });

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String selectedTheme = 'System';

  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    // Load current theme
    selectedTheme = switch (widget.themeController.themeMode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    // Load current accent color
    selectedColor = widget.themeController.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Appearance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // =========================
          // THEME
          // =========================

          Text(
            'Theme',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'System',
                  groupValue: selectedTheme,
                  activeColor: colorScheme.primary,
                  title: const Text('System Default'),
                  subtitle: const Text(
                    'Follow your device settings',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTheme = value;
                      });

                      widget.themeController.setTheme(value);
                    }
                  },
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'Light',
                  groupValue: selectedTheme,
                  activeColor: colorScheme.primary,
                  title: const Text('Light'),
                  subtitle: const Text(
                    'Use a bright appearance',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTheme = value;
                      });

                      widget.themeController.setTheme(value);
                    }
                  },
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'Dark',
                  groupValue: selectedTheme,
                  activeColor: colorScheme.primary,
                  title: const Text('Dark'),
                  subtitle: const Text(
                    'Use a dark fitness-style appearance',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTheme = value;
                      });

                      widget.themeController.setTheme(value);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // =========================
          // ACCENT COLOR
          // =========================

          Text(
            'Accent Color',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Choose the color used for buttons, icons, and highlights.',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: Column(
              children: [
                // GREEN — UNCHANGED
                _colorOption(
                  name: 'Energy Green',
                  color: const Color(0xFF43A047),
                ),

                const Divider(height: 1),

                // BLUE — DEEPER FOR BETTER VISIBILITY ON WHITE
                _colorOption(
                  name: 'Fitness Blue',
                  color: const Color(0xFF1565C0),
                ),

                const Divider(height: 1),

                // ORANGE — DEEPER FOR BETTER VISIBILITY ON WHITE
                _colorOption(
                  name: 'Energy Orange',
                  color: const Color(0xFFEF6C00),
                ),

                const Divider(height: 1),

                // PURPLE — UNCHANGED
                _colorOption(
                  name: 'Power Purple',
                  color: Colors.purple,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // =========================
          // PREVIEW
          // =========================

          Card(
            color: theme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Text(
                    'Preview',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Icon(
                    Icons.fitness_center,
                    size: 45,
                    color: selectedColor,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Your Fitness Journey',
                    style: TextStyle(
                      color: selectedColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Example Button'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // ACCENT COLOR OPTION
  // =========================

  Widget _colorOption({
    required String name,
    required Color color,
  }) {
    final bool isSelected =
        selectedColor.toARGB32() == color.toARGB32();

    return ListTile(
      onTap: () {
        setState(() {
          selectedColor = color;
        });

        widget.themeController.setAccentColor(color);
      },

      leading: Container(
        width: 35,
        height: 35,

        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),

      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 28,
            )
          : Icon(
              Icons.circle_outlined,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.35),
              size: 28,
            ),
    );
  }
}