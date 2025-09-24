import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionSettingsCard extends StatefulWidget {
  final double confidenceThreshold;
  final bool objectDetection;
  final bool currencyDetection;
  final bool peopleDetection;
  final bool continuousDetection;
  final double vibrationIntensity;
  final Function(double) onConfidenceThresholdChanged;
  final Function(bool) onObjectDetectionChanged;
  final Function(bool) onCurrencyDetectionChanged;
  final Function(bool) onPeopleDetectionChanged;
  final Function(bool) onContinuousDetectionChanged;
  final Function(double) onVibrationIntensityChanged;

  const DetectionSettingsCard({
    Key? key,
    required this.confidenceThreshold,
    required this.objectDetection,
    required this.currencyDetection,
    required this.peopleDetection,
    required this.continuousDetection,
    required this.vibrationIntensity,
    required this.onConfidenceThresholdChanged,
    required this.onObjectDetectionChanged,
    required this.onCurrencyDetectionChanged,
    required this.onPeopleDetectionChanged,
    required this.onContinuousDetectionChanged,
    required this.onVibrationIntensityChanged,
  }) : super(key: key);

  @override
  State<DetectionSettingsCard> createState() => _DetectionSettingsCardState();
}

class _DetectionSettingsCardState extends State<DetectionSettingsCard> {
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
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Detection Settings',
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

              // Confidence Threshold Slider
              _buildSliderSetting(
                title: 'Detection Confidence',
                subtitle: 'Minimum confidence level for object detection',
                value: widget.confidenceThreshold,
                min: 0.3,
                max: 0.9,
                divisions: 12,
                onChanged: widget.onConfidenceThresholdChanged,
                valueFormatter: (value) => '${(value * 100).round()}%',
              ),

              SizedBox(height: 2.h),

              // Detection Modes Section
              Text(
                'Detection Modes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),

              // Object Detection Toggle
              _buildToggleSetting(
                title: 'Object Detection',
                subtitle: 'Detect and announce household objects',
                value: widget.objectDetection,
                onChanged: widget.onObjectDetectionChanged,
                icon: 'home',
              ),

              SizedBox(height: 1.h),

              // Currency Detection Toggle
              _buildToggleSetting(
                title: 'Currency Detection',
                subtitle: 'Recognize Indian currency notes and coins',
                value: widget.currencyDetection,
                onChanged: widget.onCurrencyDetectionChanged,
                icon: 'currency_rupee',
              ),

              SizedBox(height: 1.h),

              // People Detection Toggle
              _buildToggleSetting(
                title: 'People Detection',
                subtitle: 'Detect and announce people in view',
                value: widget.peopleDetection,
                onChanged: widget.onPeopleDetectionChanged,
                icon: 'person',
              ),

              SizedBox(height: 2.h),

              // Continuous Detection Toggle
              _buildToggleSetting(
                title: 'Continuous Detection',
                subtitle: 'Keep detecting without tapping camera button',
                value: widget.continuousDetection,
                onChanged: widget.onContinuousDetectionChanged,
                icon: 'refresh',
              ),

              SizedBox(height: 2.h),

              // Vibration Intensity Slider
              _buildSliderSetting(
                title: 'Vibration Intensity',
                subtitle: 'Haptic feedback strength for detection alerts',
                value: widget.vibrationIntensity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: widget.onVibrationIntensityChanged,
                valueFormatter: (value) =>
                    value == 0.0 ? 'Off' : '${(value * 100).round()}%',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required String Function(double) valueFormatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.lightTheme.primaryColor,
                  thumbColor: AppTheme.lightTheme.primaryColor,
                  overlayColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  inactiveTrackColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  trackHeight: 4.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              width: 12.w,
              child: Text(
                valueFormatter(value),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
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
