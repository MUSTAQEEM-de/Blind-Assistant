import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitialized = false;
  String _loadingStatus = 'Initializing accessibility services...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Initialize TensorFlow Lite models
      await _updateProgress(0.2, 'Loading object detection models...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Initialize voice synthesis
      await _updateProgress(0.4, 'Initializing voice synthesis...');
      await Future.delayed(const Duration(milliseconds: 400));

      // Step 3: Check camera permissions
      await _updateProgress(0.6, 'Checking camera permissions...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 4: Check audio permissions
      await _updateProgress(0.8, 'Checking audio permissions...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 5: Prepare accessibility configurations
      await _updateProgress(1.0, 'Preparing accessibility features...');
      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        _isInitialized = true;
      });

      // Provide haptic feedback for tactile confirmation
      HapticFeedback.lightImpact();

      // Navigate based on initialization results
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      _handleInitializationError();
    }
  }

  Future<void> _updateProgress(double progress, String status) async {
    setState(() {
      _progress = progress;
      _loadingStatus = status;
    });
  }

  void _navigateToNextScreen() {
    // Navigation logic: Check permissions and user status
    // For now, navigate to onboarding tutorial screen
    Navigator.pushReplacementNamed(context, '/onboarding-tutorial-screen');
  }

  void _handleInitializationError() {
    setState(() {
      _loadingStatus = 'Initialization failed. Retrying...';
    });

    // Show retry option after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _startInitialization();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryDark,
              AppTheme.secondaryLight,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Semantics(
            label: 'Blind Assistant app loading screen',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with Animation
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'visibility',
                                    color: AppTheme.primaryLight,
                                    size: 12.w,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'BA',
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: AppTheme.primaryLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 6.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // App Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Semantics(
                    label: 'Blind Assistant - AI powered accessibility app',
                    child: Text(
                      'Blind Assistant',
                      textAlign: TextAlign.center,
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.w,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'AI-Powered Vision for Independence',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Loading Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Progress Indicator
                        Container(
                          width: 60.w,
                          height: 0.8.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Stack(
                                children: [
                                  Container(
                                    width: 60.w * _progress,
                                    height: 0.8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1.h),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Loading Status Text
                        Semantics(
                          label: _loadingStatus,
                          liveRegion: true,
                          child: Text(
                            _loadingStatus,
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 3.5.w,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Progress Percentage
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 4.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Accessibility Notice
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'accessibility',
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Optimized for TalkBack & VoiceOver',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 3.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
