import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TutorialStepWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String description;
  final VoidCallback? onPlayAudio;
  final bool isPlaying;

  const TutorialStepWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.description,
    this.onPlayAudio,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with gradient background
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(15.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: Colors.white,
                size: 12.w,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
            semanticsLabel: title,
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            constraints: BoxConstraints(maxWidth: 80.w),
            child: Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: description,
            ),
          ),

          SizedBox(height: 4.h),

          // Audio Control Button
          if (onPlayAudio != null)
            Semantics(
              label:
                  isPlaying ? 'Pause audio narration' : 'Play audio narration',
              button: true,
              child: GestureDetector(
                onTap: onPlayAudio,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7.5.w),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: isPlaying ? 'pause' : 'play_arrow',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
