import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/tutorial_step_widget.dart';

class OnboardingTutorialScreen extends StatefulWidget {
  const OnboardingTutorialScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingTutorialScreen> createState() =>
      _OnboardingTutorialScreenState();
}

class _OnboardingTutorialScreenState extends State<OnboardingTutorialScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  bool _isPlayingAudio = false;

  final List<Map<String, dynamic>> _tutorialSteps = [
    {
      "iconName": "camera_alt",
      "title": "Point and Detect",
      "description":
          "Simply point your camera at any object and tap the large detection button. Our AI will instantly identify what you're looking at and announce it clearly.",
      "audioText":
          "Welcome to step one: Point and Detect. Hold your phone steady and point the camera at any object around you. Tap the large circular button at the bottom of the screen to start detection. The app will tell you exactly what it sees.",
    },
    {
      "iconName": "volume_up",
      "title": "Listen and Learn",
      "description":
          "Every detection is announced with clear voice narration. You'll hear detailed descriptions of objects, people, and currency notes with helpful context.",
      "audioText":
          "Step two: Listen and Learn. After detection, you'll hear a clear voice announcement describing what was found. The app speaks in a natural, conversational tone and provides useful details about each item.",
    },
    {
      "iconName": "vibration",
      "title": "Feel the Feedback",
      "description":
          "Experience tactile confirmation through vibration patterns. Different vibrations indicate successful detection, errors, or when the camera is ready.",
      "audioText":
          "Final step: Feel the Feedback. Your phone will vibrate to confirm successful detections and guide you through the app. Different vibration patterns help you understand what's happening without looking at the screen.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Auto-play first step audio after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _playStepAudio(0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _playStepAudio(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= _tutorialSteps.length) return;

    setState(() {
      _isPlayingAudio = true;
    });

    // Simulate audio playback with haptic feedback
    HapticFeedback.lightImpact();

    // Simulate audio duration based on text length
    final audioText = _tutorialSteps[stepIndex]["audioText"] as String;
    final duration =
        Duration(milliseconds: (audioText.length * 50).clamp(3000, 8000));

    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
        HapticFeedback.selectionClick();
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _tutorialSteps.length - 1) {
      HapticFeedback.selectionClick();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      HapticFeedback.selectionClick();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/main-camera-screen');
  }

  void _completeTutorial() {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacementNamed(context, '/main-camera-screen');
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentStep = index;
      _isPlayingAudio = false;
    });

    // Auto-play audio for new step
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _playStepAudio(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.secondary,
              AppTheme.lightTheme.colorScheme.tertiary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header with Skip Button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App Title
                      Text(
                        'Blind Assistant',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        semanticsLabel: 'Blind Assistant Tutorial',
                      ),

                      // Skip Button
                      Semantics(
                        label: 'Skip tutorial and go directly to main app',
                        button: true,
                        child: GestureDetector(
                          onTap: _skipTutorial,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2.h),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Skip Tutorial',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress Indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: ProgressIndicatorWidget(
                    currentStep: _currentStep,
                    totalSteps: _tutorialSteps.length,
                  ),
                ),

                // Tutorial Steps PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _tutorialSteps.length,
                    itemBuilder: (context, index) {
                      final step = _tutorialSteps[index];
                      return TutorialStepWidget(
                        iconName: step["iconName"] as String,
                        title: step["title"] as String,
                        description: step["description"] as String,
                        onPlayAudio: () => _playStepAudio(index),
                        isPlaying: _isPlayingAudio && _currentStep == index,
                      );
                    },
                  ),
                ),

                // Navigation Controls
                NavigationControlsWidget(
                  currentStep: _currentStep,
                  totalSteps: _tutorialSteps.length,
                  onPrevious: _currentStep > 0 ? _previousStep : null,
                  onNext: _currentStep < _tutorialSteps.length - 1
                      ? _nextStep
                      : null,
                  onComplete: _currentStep == _tutorialSteps.length - 1
                      ? _completeTutorial
                      : null,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
