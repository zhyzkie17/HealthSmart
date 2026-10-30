import 'package:flutter/foundation.dart';

class NavigationController {
  static final ValueNotifier<int> currentIndex =
    ValueNotifier<int>(0);

  static final ValueNotifier<bool> isProfileSetup =
    ValueNotifier<bool>(false);

  static void goToHome() {
    currentIndex.value = 0;
  }

  static void goToExercise() {
    currentIndex.value = 1;
  }

  static void goToSchedule() {
    currentIndex.value = 2;
  }

  static void goToFood() {
    currentIndex.value = 3;
  }

  static void goToProfile() {
    currentIndex.value = 4;
  }

  static void startProfileSetup() {
    isProfileSetup.value = true;
    currentIndex.value = 4;
  }

  static void finishProfileSetup() {
    isProfileSetup.value = false;
    currentIndex.value = 2;
  }

  static void finishProfileSetupWithoutNavigation() {
    isProfileSetup.value = false;
  }
}