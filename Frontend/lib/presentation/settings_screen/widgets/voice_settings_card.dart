import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSettingsCard extends StatefulWidget {
  final double speechRate;
  final String selectedVoice;
  final bool announcementVerbosity;
  final bool audioDucking;
  final Function(double) onSpeechRateChanged;
  final Function(String) onVoiceChanged;
  final Function(bool) onAnnouncementVerbosityChanged;
  final Function(bool) onAudioDuckingChanged;

  const VoiceSettingsCard({
    Key? key,
    required this.speechRate,
    required this.selectedVoice,
    required this.announcementVerbosity,
    required this.audioDucking,
    required this.onSpeechRateChanged,
    required this.onVoiceChanged,
    required this.onAnnouncementVerbosityChanged,
    required this.onAudioDuckingChanged,
  }) : super(key: key);

  @override
  State<VoiceSettingsCard> createState() => _VoiceSettingsCardState();
}

class _VoiceSettingsCardState extends State<VoiceSettingsCard> {
  final List<String> _voiceOptions = [
    'Default Voice',
    'Female Voice',
    'Male Voice',
    'High Pitch',
    'Low Pitch'
  ];

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
                    iconName: 'volume_up',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Voice Settings',
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

              // Speech Rate Slider
              _buildSliderSetting(
                title: 'Speech Rate',
                subtitle: 'Adjust how fast the voice speaks',
                value: widget.speechRate,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                onChanged: widget.onSpeechRateChanged,
                valueFormatter: (value) => '${(value * 100).round()}%',
              ),

              SizedBox(height: 2.h),

              // Voice Selection Dropdown
              _buildDropdownSetting(
                title: 'Voice Selection',
                subtitle: 'Choose your preferred voice type',
                value: widget.selectedVoice,
                options: _voiceOptions,
                onChanged: widget.onVoiceChanged,
              ),

              SizedBox(height: 2.h),

              // Announcement Verbosity Toggle
              _buildToggleSetting(
                title: 'Detailed Announcements',
                subtitle: 'Include additional details in voice announcements',
                value: widget.announcementVerbosity,
                onChanged: widget.onAnnouncementVerbosityChanged,
              ),

              SizedBox(height: 1.h),

              // Audio Ducking Toggle
              _buildToggleSetting(
                title: 'Audio Ducking',
                subtitle: 'Lower other audio when speaking',
                value: widget.audioDucking,
                onChanged: widget.onAudioDuckingChanged,
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

  Widget _buildDropdownSetting({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
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
