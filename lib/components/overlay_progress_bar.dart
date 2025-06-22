import 'package:flutter/material.dart';

class OverlayProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OverlayProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentStep + 1) / totalSteps;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth * progress;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  height: 12,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Checkpoints (dots)
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (i) {
                  final isReached = i <= currentStep;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isReached ? Colors.green[600] : Colors.transparent,
                      border: Border.all(
                        color: isReached
                            ? Colors.greenAccent[400]!
                            : Colors.white,
                        width: 2.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isReached
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
