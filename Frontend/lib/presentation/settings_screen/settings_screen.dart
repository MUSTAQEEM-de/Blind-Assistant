import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/accessibility_settings_card.dart';
import './widgets/advanced_settings_card.dart';
import './widgets/detection_settings_card.dart';
import './widgets/voice_settings_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Voice Settings State
  double _speechRate = 1.0;
  String _selectedVoice = 'Default Voice';
  bool _announcementVerbosity = true;
  bool _audioDucking = true;

  // Detection Settings State
  double _confidenceThreshold = 0.7;
  bool _objectDetection = true;
  bool _currencyDetection = true;
  bool _peopleDetection = true;
  bool _continuousDetection = false;
  double _vibrationIntensity = 0.8;

  // Accessibility Settings State
  bool _highContrastMode = false;
  bool _largeTextSupport = false;
  bool _reducedMotion = false;
  bool _screenReaderOptimization = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSettings();
  }

  void _initializeAnimations() {
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _loadSettings() {
    // In a real app, load settings from SharedPreferences
    // For now, using default values
  }

  void _saveSettings() {
    // In a real app, save settings to SharedPreferences
    _showToast('Settings saved successfully');
    HapticFeedback.lightImpact();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.warningColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Reset Settings',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _performReset() {
    setState(() {
      // Reset Voice Settings
      _speechRate = 1.0;
      _selectedVoice = 'Default Voice';
      _announcementVerbosity = true;
      _audioDucking = true;

      // Reset Detection Settings
      _confidenceThreshold = 0.7;
      _objectDetection = true;
      _currencyDetection = true;
      _peopleDetection = true;
      _continuousDetection = false;
      _vibrationIntensity = 0.8;

      // Reset Accessibility Settings
      _highContrastMode = false;
      _largeTextSupport = false;
      _reducedMotion = false;
      _screenReaderOptimization = true;
    });

    _saveSettings();
    _showToast('Settings reset to defaults');
    HapticFeedback.mediumImpact();
  }

  void _exportSettings() {
    // In a real app, export settings to a file
    _showToast('Settings exported successfully');
    HapticFeedback.lightImpact();
  }

  void _showAccessibilityHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Accessibility Help',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Getting Started:',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Enable TalkBack (Android) or VoiceOver (iOS) in your device settings\n'
                  '• Use headphones for better voice feedback\n'
                  '• Adjust speech rate to your preference\n'
                  '• Enable high contrast mode for better visibility',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Camera Usage:',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Point camera at objects for detection\n'
                  '• Use continuous detection for hands-free operation\n'
                  '• Adjust confidence threshold for accuracy\n'
                  '• Enable vibration for tactile feedback',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'Settings',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: _saveSettings,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'save',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Content
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 1.h),

                              // Voice Settings Card
                              VoiceSettingsCard(
                                speechRate: _speechRate,
                                selectedVoice: _selectedVoice,
                                announcementVerbosity: _announcementVerbosity,
                                audioDucking: _audioDucking,
                                onSpeechRateChanged: (value) {
                                  setState(() => _speechRate = value);
                                  HapticFeedback.selectionClick();
                                },
                                onVoiceChanged: (value) {
                                  setState(() => _selectedVoice = value);
                                  HapticFeedback.selectionClick();
                                },
                                onAnnouncementVerbosityChanged: (value) {
                                  setState(
                                      () => _announcementVerbosity = value);
                                  HapticFeedback.lightImpact();
                                },
                                onAudioDuckingChanged: (value) {
                                  setState(() => _audioDucking = value);
                                  HapticFeedback.lightImpact();
                                },
                              ),

                              // Detection Settings Card
                              DetectionSettingsCard(
                                confidenceThreshold: _confidenceThreshold,
                                objectDetection: _objectDetection,
                                currencyDetection: _currencyDetection,
                                peopleDetection: _peopleDetection,
                                continuousDetection: _continuousDetection,
                                vibrationIntensity: _vibrationIntensity,
                                onConfidenceThresholdChanged: (value) {
                                  setState(() => _confidenceThreshold = value);
                                  HapticFeedback.selectionClick();
                                },
                                onObjectDetectionChanged: (value) {
                                  setState(() => _objectDetection = value);
                                  HapticFeedback.lightImpact();
                                },
                                onCurrencyDetectionChanged: (value) {
                                  setState(() => _currencyDetection = value);
                                  HapticFeedback.lightImpact();
                                },
                                onPeopleDetectionChanged: (value) {
                                  setState(() => _peopleDetection = value);
                                  HapticFeedback.lightImpact();
                                },
                                onContinuousDetectionChanged: (value) {
                                  setState(() => _continuousDetection = value);
                                  HapticFeedback.lightImpact();
                                },
                                onVibrationIntensityChanged: (value) {
                                  setState(() => _vibrationIntensity = value);
                                  HapticFeedback.selectionClick();
                                },
                              ),

                              // Accessibility Settings Card
                              AccessibilitySettingsCard(
                                highContrastMode: _highContrastMode,
                                largeTextSupport: _largeTextSupport,
                                reducedMotion: _reducedMotion,
                                screenReaderOptimization:
                                    _screenReaderOptimization,
                                onHighContrastModeChanged: (value) {
                                  setState(() => _highContrastMode = value);
                                  HapticFeedback.lightImpact();
                                },
                                onLargeTextSupportChanged: (value) {
                                  setState(() => _largeTextSupport = value);
                                  HapticFeedback.lightImpact();
                                },
                                onReducedMotionChanged: (value) {
                                  setState(() => _reducedMotion = value);
                                  HapticFeedback.lightImpact();
                                },
                                onScreenReaderOptimizationChanged: (value) {
                                  setState(
                                      () => _screenReaderOptimization = value);
                                  HapticFeedback.lightImpact();
                                },
                              ),

                              // Advanced Settings Card
                              AdvancedSettingsCard(
                                onResetToDefaults: _resetToDefaults,
                                onExportSettings: _exportSettings,
                                onAccessibilityHelp: _showAccessibilityHelp,
                              ),

                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
