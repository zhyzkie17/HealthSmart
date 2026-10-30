import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_control.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

// Start the app and prepare Firebase.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('STEP 1: Flutter initialized');

  // Connect the app to Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('STEP 2: Firebase initialized');

  // Check that app requests come from an approved app.
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'),
  );

  print('STEP 3: App Check initialized');

  // Open the app.
  runApp(const FitnessApp());
}

// Set up the main app.
class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

// Manage the app's settings and appearance.
class _FitnessAppState extends State<FitnessApp> {
  late final ThemeController themeController;

  bool settingsLoaded = false;

  @override
  void initState() {
    super.initState();

    themeController = ThemeController();

    // Listen for changes to the app's appearance.
    themeController.addListener(_onThemeChanged);

    // Load the saved appearance settings.
    _initializeTheme();
  }

  // Wait until the saved settings are ready.
  Future<void> _initializeTheme() async {
    await themeController.ready;

    if (!mounted) return;

    setState(() {
      settingsLoaded = true;
    });
  }

  // Update the screen when the appearance changes.
  void _onThemeChanged() {
    if (!mounted) return;

    setState(() {});
  }

  // Clean up when this screen is removed.
  @override
  void dispose() {
    themeController.removeListener(_onThemeChanged);
    themeController.dispose();

    super.dispose();
  }

  // Build the app's screen.
  @override
  Widget build(BuildContext context) {
    // Show a loading screen while settings are being loaded.
    if (!settingsLoaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Set up the app's name, themes, and first screen.
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Stryve',

      // Set the light appearance.
      theme: AppTheme.lightTheme(
        themeController.accentColor,
      ),

      // Set the dark appearance.
      darkTheme: AppTheme.darkTheme(
        themeController.accentColor,
      ),

      // Use the appearance selected by the user.
      themeMode: themeController.themeMode,

      // Open the welcome screen first.
      home: WelcomeScreen(
        themeController: themeController,
      ),
    );
  }
}