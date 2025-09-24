import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccessibilitySettingsCard extends StatefulWidget {
  final bool highContrastMode;
  final bool largeTextSupport;
  final bool reducedMotion;
  final bool screenReaderOptimization;
  final Function(bool) onHighContrastModeChanged;
  final Function(bool) onLargeTextSupportChanged;
  final Function(bool) onReducedMotionChanged;
  final Function(bool) onScreenReaderOptimizationChanged;

  const AccessibilitySettingsCard({
    Key? key,
    required this.highContrastMode,
    required this.largeTextSupport,
    required this.reducedMotion,
    required this.screenReaderOptimization,
    required this.onHighContrastModeChanged,
    required this.onLargeTextSupportChanged,
    required this.onReducedMotionChanged,
    required this.onScreenReaderOptimizationChanged,
  }) : super(key: key);

  @override
  State<AccessibilitySettingsCard> createState() =>
      _AccessibilitySettingsCardState();
}

class _AccessibilitySettingsCardState extends State<AccessibilitySettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'accessibility',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Accessibility',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // High Contrast Mode Toggle
              _buildToggleSetting(
                title: 'High Contrast Mode',
                subtitle: 'Increase color contrast for better visibility',
                value: widget.highContrastMode,
                onChanged: widget.onHighContrastModeChanged,
                icon: 'contrast',
              ),

              SizedBox(height: 1.h),

              // Large Text Support Toggle
              _buildToggleSetting(
                title: 'Large Text Support',
                subtitle: 'Use larger fonts throughout the app',
                value: widget.largeTextSupport,
                onChanged: widget.onLargeTextSupportChanged,
                icon: 'text_fields',
              ),

              SizedBox(height: 1.h),

              // Reduced Motion Toggle
              _buildToggleSetting(
                title: 'Reduced Motion',
                subtitle: 'Minimize animations and transitions',
                value: widget.reducedMotion,
                onChanged: widget.onReducedMotionChanged,
                icon: 'motion_photos_off',
              ),

              SizedBox(height: 1.h),

              // Screen Reader Optimization Toggle
              _buildToggleSetting(
                title: 'Screen Reader Optimization',
                subtitle: 'Enhanced TalkBack and VoiceOver support',
                value: widget.screenReaderOptimization,
                onChanged: widget.onScreenReaderOptimizationChanged,
                icon: 'record_voice_over',
              ),

              SizedBox(height: 2.h),

              // Accessibility Tips Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Accessibility Tips',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '• Enable TalkBack (Android) or VoiceOver (iOS) in device settings\n'
                      '• Use headphones for better voice feedback\n'
                      '• Adjust device brightness for optimal contrast\n'
                      '• Enable haptic feedback in device settings',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String icon,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: value
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        SizedBox(width: 3.w),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.lightTheme.primaryColor,
          activeTrackColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
          inactiveThumbColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5),
          inactiveTrackColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
