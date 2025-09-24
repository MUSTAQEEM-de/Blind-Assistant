import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onDetectAgain;
  final VoidCallback onSaveToHistory;
  final VoidCallback onShareResult;

  const ActionButtonsWidget({
    Key? key,
    required this.onDetectAgain,
    required this.onSaveToHistory,
    required this.onShareResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary Action Button
          Semantics(
            label: "Detect again button",
            button: true,
            child: SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onDetectAgain();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryLight,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppTheme.primaryLight.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Detect Again',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary Action Buttons Row
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: "Save to history button",
                  button: true,
                  child: SizedBox(
                    height: 6.h,
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onSaveToHistory();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryLight,
                        side: BorderSide(
                          color: AppTheme.primaryLight,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'bookmark',
                            color: AppTheme.primaryLight,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Text(
                              'Save',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Semantics(
                  label: "Share result button",
                  button: true,
                  child: SizedBox(
                    height: 6.h,
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onShareResult();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryLight,
                        backgroundColor:
                            AppTheme.primaryLight.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.primaryLight,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Text(
                              'Share',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
