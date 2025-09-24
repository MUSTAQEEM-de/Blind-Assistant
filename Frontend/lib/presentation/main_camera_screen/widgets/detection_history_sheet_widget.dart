import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionHistorySheetWidget extends StatelessWidget {
  final List<Map<String, dynamic>> detectionHistory;
  final Function(String) onReplayAnnouncement;

  const DetectionHistorySheetWidget({
    Key? key,
    required this.detectionHistory,
    required this.onReplayAnnouncement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Detection History',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: detectionHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No detections yet',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: detectionHistory.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.1),
                    ),
                    itemBuilder: (context, index) {
                      final detection = detectionHistory[index];
                      return Semantics(
                        label:
                            'Detection ${index + 1}: ${detection['text']} at ${detection['time']}',
                        hint: 'Tap to replay announcement',
                        button: true,
                        child: ListTile(
                          leading: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: _getDetectionIcon(
                                    detection['type'] as String),
                                color: AppTheme.primaryLight,
                                size: 5.w,
                              ),
                            ),
                          ),
                          title: Text(
                            detection['text'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            detection['time'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => onReplayAnnouncement(
                                detection['text'] as String),
                            icon: CustomIconWidget(
                              iconName: 'replay',
                              color: AppTheme.primaryLight,
                              size: 6.w,
                            ),
                            tooltip: 'Replay announcement',
                          ),
                          onTap: () =>
                              onReplayAnnouncement(detection['text'] as String),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getDetectionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'object':
        return 'category';
      case 'currency':
        return 'attach_money';
      case 'person':
        return 'person';
      default:
        return 'visibility';
    }
  }
}
