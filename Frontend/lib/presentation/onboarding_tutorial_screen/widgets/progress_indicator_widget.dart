import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tutorial progress: step ${currentStep + 1} of $totalSteps',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isPassed = index < currentStep;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 8.w : 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: isActive || isPassed
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.5.w),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
