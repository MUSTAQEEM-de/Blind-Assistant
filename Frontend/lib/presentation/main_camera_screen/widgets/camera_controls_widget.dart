import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final bool isFlashOn;
  final double zoomLevel;
  final VoidCallback onFlashToggle;
  final Function(double) onZoomChanged;
  final VoidCallback onSettingsTap;

  const CameraControlsWidget({
    Key? key,
    required this.isFlashOn,
    required this.zoomLevel,
    required this.onFlashToggle,
    required this.onZoomChanged,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Settings button
        Semantics(
          label: 'Settings',
          hint: 'Open app settings',
          button: true,
          child: Container(
            margin: EdgeInsets.only(right: 4.w, top: 2.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSettingsTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        // Flash toggle button
        Semantics(
          label: isFlashOn ? 'Flash on' : 'Flash off',
          hint: 'Tap to toggle flash',
          button: true,
          child: Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFlashToggle,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isFlashOn
                        ? AppTheme.primaryLight.withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: isFlashOn ? 'flash_on' : 'flash_off',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        // Zoom slider
        Semantics(
          label: 'Zoom level ${(zoomLevel * 100).round()}%',
          hint: 'Drag to adjust zoom',
          slider: true,
          child: Container(
            margin: EdgeInsets.only(right: 4.w),
            height: 30.h,
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16),
                  activeTrackColor: AppTheme.primaryLight,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                  thumbColor: AppTheme.primaryLight,
                  overlayColor: AppTheme.primaryLight.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: zoomLevel,
                  min: 1.0,
                  max: 5.0,
                  divisions: 20,
                  onChanged: onZoomChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
