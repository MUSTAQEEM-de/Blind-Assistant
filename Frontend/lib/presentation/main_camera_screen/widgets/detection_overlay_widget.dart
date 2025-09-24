import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DetectionOverlayWidget extends StatelessWidget {
  final List<Map<String, dynamic>> detectedObjects;

  const DetectionOverlayWidget({
    Key? key,
    required this.detectedObjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: detectedObjects.map((detection) {
        return Positioned(
          left: (detection['x'] as double) * 100.w / 100,
          top: (detection['y'] as double) * 100.h / 100,
          child: Semantics(
            label: 'Detected: ${detection['name']}',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.yellow.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                detection['name'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
