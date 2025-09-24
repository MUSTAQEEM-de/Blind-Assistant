import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionModeIndicatorWidget extends StatelessWidget {
  final String currentMode;
  final VoidCallback onModeTap;

  const DetectionModeIndicatorWidget({
    Key? key,
    required this.currentMode,
    required this.onModeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Current detection mode: $currentMode',
      hint: 'Tap to change detection mode',
      button: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onModeTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getModeIcon(currentMode),
                    color: Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    currentMode,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: Colors.white,
                    size: 4.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'objects':
        return 'category';
      case 'currency':
        return 'attach_money';
      case 'people':
        return 'people';
      default:
        return 'visibility';
    }
  }
}
