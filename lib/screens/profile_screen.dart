import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'app_settings_screen.dart';
import '../theme/theme_control.dart';
import 'notification_settings_screen.dart';
import '../services/navigation_control.dart';

class ProfileScreen extends StatefulWidget {
  final ThemeController themeController;
  final bool isSetup;

  const ProfileScreen({
    super.key,
    required this.themeController,
    this.isSetup = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedGoal = 'General Fitness';
  String selectedFocus = 'Strength';

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String activityLevel = 'Moderately Active';

  // ============================================================
  // LOAD PROFILE DATA
  // ============================================================

  Future<void> loadProfileData() async {
    final user = await DatabaseService.getUser();

    if (user == null || !mounted) {
      return;
    }

    setState(() {
      ageController.text = user['age'].toString();
      heightController.text = user['height'].toString();
      weightController.text = user['weight'].toString();

      activityLevel = user['activityLevel'];
      selectedGoal = user['goal'];
      selectedFocus = user['focus'];
    });
  }

  // ============================================================
  // PERSONAL INFORMATION
  // ============================================================

  void showPersonalInformation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(
                      Icons.cake_outlined,
                      color: colors.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(
                      Icons.height,
                      color: colors.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: colors.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: activityLevel,
                  decoration: InputDecoration(
                    labelText: 'Activity Level',
                    prefixIcon: Icon(
                      Icons.directions_walk,
                      color: colors.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Sedentary',
                      child: Text('Sedentary'),
                    ),
                    DropdownMenuItem(
                      value: 'Lightly Active',
                      child: Text('Lightly Active'),
                    ),
                    DropdownMenuItem(
                      value: 'Moderately Active',
                      child: Text('Moderately Active'),
                    ),
                    DropdownMenuItem(
                      value: 'Very Active',
                      child: Text('Very Active'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        activityLevel = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      final int? age =
                          int.tryParse(ageController.text);

                      final double? height =
                          double.tryParse(heightController.text);

                      final double? weight =
                          double.tryParse(weightController.text);

                      if (age == null ||
                          height == null ||
                          weight == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter valid age, height, and weight.',
                            ),
                          ),
                        );
                        return;
                      }

                      await DatabaseService.saveUser(
                        age: age,
                        height: height,
                        weight: weight,
                        activityLevel: activityLevel,
                        goal: selectedGoal,
                        focus: selectedFocus,
                      );

                      if (!mounted) return;

                      setState(() {});

                      Navigator.pop(context);

                      if (widget.isSetup) {
                        final status = await DatabaseService.getSetupStatus();

                        if (!mounted) return;

                        if (status['scheduleCompleted'] == 1) {
                          NavigationController.finishProfileSetupWithoutNavigation();
                        } else {
                          NavigationController.finishProfileSetup();
                        }
                      }
                    },
                    child: const Text(
                      'SAVE INFORMATION',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // GOAL SELECTION
  // ============================================================

  void showGoalSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Main Goal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Choose what you want to focus on in your fitness journey.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 15),

                _goalOption(
                  icon: Icons.local_fire_department,
                  title: 'Cut',
                  description:
                      'Focus on reducing body fat while maintaining healthy habits.',
                ),

                _goalOption(
                  icon: Icons.fitness_center,
                  title: 'Bulk',
                  description:
                      'Focus on building muscle and gaining body mass in a healthy way.',
                ),

                _goalOption(
                  icon: Icons.balance,
                  title: 'Maintain',
                  description:
                      'Maintain your current weight and fitness level.',
                ),

                _goalOption(
                  icon: Icons.sync,
                  title: 'Body Recomposition',
                  description:
                      'Work toward improving body composition and muscle development.',
                ),

                _goalOption(
                  icon: Icons.directions_run,
                  title: 'General Fitness',
                  description:
                      'Improve your overall health, fitness, and activity.',
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _goalOption({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isSelected = selectedGoal == title;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () async {
          setState(() {
            selectedGoal = title;
          });

          final age = int.tryParse(ageController.text);
          final height = double.tryParse(heightController.text);
          final weight = double.tryParse(weightController.text);

          if (age != null && height != null && weight != null) {
            await DatabaseService.saveUser(
              age: age,
              height: height,
              weight: weight,
              activityLevel: activityLevel,
              goal: selectedGoal,
              focus: selectedFocus,
            );
          }

          if (!mounted) return;

          Navigator.pop(context);
        },

        leading: Icon(
          icon,
          color: colors.primary,
          size: 30,
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: colors.onSurface,
          ),
        ),

        subtitle: Text(
          description,
          style: TextStyle(
            color: colors.onSurfaceVariant,
          ),
        ),

        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: colors.primary,
              )
            : Icon(
                Icons.circle_outlined,
                color: colors.onSurfaceVariant,
              ),
      ),
    );
  }

  // ============================================================
  // FOCUS SELECTION
  // ============================================================

  void showFocusSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Fitness Focus',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Choose the area of fitness you want to develop.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 15),

                _focusOption(
                  icon: Icons.fitness_center,
                  title: 'Strength',
                  description:
                      'Improve strength and muscle performance.',
                ),

                _focusOption(
                  icon: Icons.self_improvement,
                  title: 'Flexibility',
                  description:
                      'Improve mobility and flexibility.',
                ),

                _focusOption(
                  icon: Icons.favorite,
                  title: 'Endurance',
                  description:
                      'Improve stamina and cardiovascular fitness.',
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _focusOption({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isSelected = selectedFocus == title;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () async {
          setState(() {
            selectedFocus = title;
          });

          final age = int.tryParse(ageController.text);
          final height = double.tryParse(heightController.text);
          final weight = double.tryParse(weightController.text);

          if (age != null && height != null && weight != null) {
            await DatabaseService.saveUser(
              age: age,
              height: height,
              weight: weight,
              activityLevel: activityLevel,
              goal: selectedGoal,
              focus: selectedFocus,
            );
          }

          if (!mounted) return;

          Navigator.pop(context);
        },

        leading: Icon(
          icon,
          color: colors.primary,
          size: 30,
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: colors.onSurface,
          ),
        ),

        subtitle: Text(
          description,
          style: TextStyle(
            color: colors.onSurfaceVariant,
          ),
        ),

        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: colors.primary,
              )
            : Icon(
                Icons.circle_outlined,
                color: colors.onSurfaceVariant,
              ),
      ),
    );
  }

  // ============================================================
  // INIT / DISPOSE
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;


    // This keeps the page background controlled by Light/Dark theme.
    final pageBackground = theme.brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    // Soft accent background for icon containers.
    final accentSoft = colors.primary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: pageBackground,

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ====================================================
            // PROFILE HEADER
            // ====================================================

            Center(
              child: Column(
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentSoft,
                    ),

                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: colors.primary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Stryve Member',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Keep working toward your goals!',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // FITNESS GOALS
            // ====================================================

            Text(
              'My Fitness Goals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            // MAIN GOAL
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.flag,
                    color: colors.primary,
                  ),
                ),

                title: Text(
                  'Main Goal',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    selectedGoal,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                trailing: TextButton(
                  onPressed: showGoalSelection,
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // FITNESS FOCUS
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.fitness_center,
                    color: colors.primary,
                  ),
                ),

                title: Text(
                  'Fitness Focus',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    selectedFocus,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                trailing: TextButton(
                  onPressed: showFocusSelection,
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // PERSONAL INFORMATION
            // ====================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              TextButton(
                onPressed: showPersonalInformation,
                child: Text(
                  'EDIT',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(

                    leading: Icon(
                      Icons.height,
                      color: colors.primary,
                    ),

                    title: Text(
                      'Height',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    subtitle: Text(
                      heightController.text.isEmpty
                          ? 'Not set'
                          : '${heightController.text} cm',
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
                      Icons.monitor_weight_outlined,
                      color: colors.primary,
                    ),

                    title: Text(
                      'Weight',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    subtitle: Text(
                      weightController.text.isEmpty
                          ? 'Not set'
                          : '${weightController.text} kg',
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
                      Icons.cake_outlined,
                      color: colors.primary,
                    ),

                    title: Text(
                      'Age',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    subtitle: Text(
                      ageController.text.isEmpty
                          ? 'Not set'
                          : '${ageController.text} years old',
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
                      Icons.directions_walk,
                      color: colors.primary,
                    ),

                    title: Text(
                      'Activity Level',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    subtitle: Text(
                      activityLevel,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // SETTINGS
            // ====================================================

            Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationSettingsScreen(),
                        ),
                      );
                    },

                    leading: Icon(
                      Icons.notifications_outlined,
                      color: colors.primary,
                    ),

                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    subtitle: Text(
                      'Workout reminders and 5-minute heads-up',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: colors.outlineVariant,
                  ),

                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppSettingsScreen(
                            themeController:
                                widget.themeController,
                          ),
                        ),
                      );
                    },

                    leading: Icon(
                      Icons.settings_outlined,
                      color: colors.primary,
                    ),

                    title: Text(
                      'App Settings',
                      style: TextStyle(
                        color: colors.onSurface,
                      ),
                    ),

                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}