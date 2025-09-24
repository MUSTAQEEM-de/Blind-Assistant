import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String objectName;

  const DetectionImageWidget({
    Key? key,
    this.imageUrl,
    required this.objectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? Semantics(
                label: "Image of detected $objectName",
                child: CustomImageWidget(
                  imageUrl: imageUrl!,
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'image',
                        color: AppTheme.primaryLight,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Semantics(
                        label: "No image available for $objectName",
                        child: Text(
                          'No Image Available',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.primaryLight,
                            fontWeight: FontWeight.w500,
                          ),
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
