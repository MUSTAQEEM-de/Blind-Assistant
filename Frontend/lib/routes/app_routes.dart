import 'package:flutter/material.dart';
import '../presentation/permission_request_screen/permission_request_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/main_camera_screen/main_camera_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/detection_results_screen/detection_results_screen.dart';
import '../presentation/onboarding_tutorial_screen/onboarding_tutorial_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String permissionRequest = '/permission-request-screen';
  static const String splash = '/splash-screen';
  static const String mainCamera = '/main-camera-screen';
  static const String settings = '/settings-screen';
  static const String detectionResults = '/detection-results-screen';
  static const String onboardingTutorial = '/onboarding-tutorial-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    permissionRequest: (context) => const PermissionRequestScreen(),
    splash: (context) => const SplashScreen(),
    mainCamera: (context) => const MainCameraScreen(),
    settings: (context) => const SettingsScreen(),
    detectionResults: (context) => const DetectionResultsScreen(),
    onboardingTutorial: (context) => const OnboardingTutorialScreen(),
    // TODO: Add your other routes here
  };
}
