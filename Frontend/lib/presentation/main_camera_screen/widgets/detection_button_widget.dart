import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionButtonWidget extends StatefulWidget {
  final bool isDetecting;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DetectionButtonWidget({
    Key? key,
    required this.isDetecting,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<DetectionButtonWidget> createState() => _DetectionButtonWidgetState();
}

class _DetectionButtonWidgetState extends State<DetectionButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isDetecting) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DetectionButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDetecting != oldWidget.isDetecting) {
      if (widget.isDetecting) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.isDetecting ? 'Stop detection' : 'Start detection',
      hint:
          'Double tap to repeat last announcement, long press for continuous mode',
      button: true,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryLight,
                  AppTheme.primaryDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
                if (widget.isDetecting)
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(
                      alpha: 0.6 * _glowAnimation.value,
                    ),
                    blurRadius: 20 + (10 * _glowAnimation.value),
                    spreadRadius: 4 + (2 * _glowAnimation.value),
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                borderRadius: BorderRadius.circular(10.w),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: widget.isDetecting ? 'stop' : 'camera_alt',
                      color: Colors.white,
                      size: 8.w,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
