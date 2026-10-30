import 'package:flutter/material.dart';
import '../theme/theme_control.dart';
import 'home_screen.dart';
import 'exercise_screen.dart';
import 'food_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';
import '../services/AI/ai_floating_button.dart';
import '../services/navigation_control.dart';
import '../services/database_service.dart';

class MainNavigation extends StatefulWidget {
  final ThemeController themeController;

  const MainNavigation({
    super.key,
    required this.themeController,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    NavigationController.currentIndex.addListener(
      _onNavigationChanged
    );
  }

  void _onNavigationChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      currentIndex = NavigationController.currentIndex.value;
    });
  }

  @override
  void dispose() {
    NavigationController.currentIndex.removeListener(
      _onNavigationChanged,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ============================================================
    // COLORS
    // ============================================================
    //
    // ACCENT COLOR:
    // Used for icons and buttons.
    //
    // BACKGROUND:
    // Remains completely independent from the accent color.
    //

    final accentColor = widget.themeController.accentColor;

    final backgroundColor = isDark
        ? const Color(0xFF181A1B)
        : const Color(0xFFF8FBF8);

    // Neutral navigation indicator.
    // IMPORTANT:
    // This does NOT use the accent color.
    final navigationIndicatorColor = isDark
        ? const Color(0xFF303333)
        : const Color(0xFFE3E9E5);

    // ============================================================
    // SCREENS
    // ============================================================

    final List<Widget> screens = [
      const HomeScreen(),
      const ExerciseScreen(),
      const ScheduleScreen(),
      const FoodScreen(),
      ProfileScreen(
        themeController: widget.themeController,
        isSetup: NavigationController.isProfileSetup.value,
      ),
    ];

    // ============================================================
    // MAIN NAVIGATION
    // ============================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              screens[currentIndex],

              AIFloatingButton(
                contentWidth: constraints.maxWidth,
                contentHeight: constraints.maxHeight,
              ),
            ],
          );
        },
      ),

      // ============================================================
      // BOTTOM NAVIGATION BAR
      // ============================================================

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) async {
          final status = await DatabaseService.getSetupStatus();

          final profileCompleted =
              status['profileCompleted'] == 1;

          final scheduleCompleted =
              status['scheduleCompleted'] == 1;

          // Home and Profile are always available.
          if (index == 0 || index == 4) {
            NavigationController.currentIndex.value = index;
            return;
          }

          // Profile is not complete yet.
          // Schedule, Exercise, and Food remain locked.
          if (!profileCompleted) {
            return;
          }

          // Profile is complete, but Schedule is not.
          // Only Schedule becomes available.
          if (!scheduleCompleted) {
            if (index == 2) {
              NavigationController.goToSchedule();
            }

            return;
          }

          // Profile and Schedule are complete.
          // Everything is unlocked.
          NavigationController.currentIndex.value = index;
        },

        // ----------------------------------------------------------
        // BACKGROUND
        // ----------------------------------------------------------
        //
        // NEVER use accentColor here.
        //
        backgroundColor: backgroundColor,

        // Prevent Material 3 from adding an accent-colored
        // surface tint.
        surfaceTintColor: Colors.transparent,

        // ----------------------------------------------------------
        // SELECTED ITEM INDICATOR
        // ----------------------------------------------------------
        //
        // Neutral color.
        // The icon itself receives the accent.
        //
        indicatorColor: navigationIndicatorColor,

        // ----------------------------------------------------------
        // LABELS
        // ----------------------------------------------------------

        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              );
            }

            return TextStyle(
              color: isDark
                  ? const Color(0xFFB8C4BD)
                  : const Color(0xFF49665D),
            );
          },
        ),

        // ----------------------------------------------------------
        // ICONS
        // ----------------------------------------------------------
        //
        // ACCENT COLOR IS USED HERE.
        //

        // ==========================================================
        // DESTINATIONS
        // ==========================================================

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: accentColor,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: accentColor,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.fitness_center_outlined,
              color: accentColor,
            ),
            selectedIcon: Icon(
              Icons.fitness_center,
              color: accentColor,
            ),
            label: 'Exercise',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: accentColor,
            ),
            selectedIcon: Icon(
              Icons.calendar_today,
              color: accentColor,
            ),
            label: 'Schedule',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.restaurant_outlined,
              color: accentColor,
            ),
            selectedIcon: Icon(
              Icons.restaurant,
              color: accentColor,
            ),
            label: 'Food',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: accentColor,
            ),
            selectedIcon: Icon(
              Icons.person,
              color: accentColor,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}