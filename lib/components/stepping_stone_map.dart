import 'package:flutter/material.dart';

class ProgressMap extends StatelessWidget {
  final int totalLevels;
  final int currentLevel; // 0-based
  final void Function(int)? onLevelTap;

  const ProgressMap({
    super.key,
    required this.totalLevels,
    required this.currentLevel,
    this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      itemCount: totalLevels,
      itemBuilder: (context, idx) {
        final isCurrent = idx == currentLevel;
        final isComplete = idx < currentLevel;

        return GestureDetector(
          onTap: onLevelTap != null ? () => onLevelTap!(idx) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 24),
              // Level Node
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isCurrent ? 44 : 36,
                    height: isCurrent ? 44 : 36,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.orange
                          : isComplete
                          ? Colors.green
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent
                            ? Colors.orange.shade700
                            : isComplete
                            ? Colors.green.shade700
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrent
                              ? Colors.white
                              : isComplete
                              ? Colors.white
                              : Colors.black54,
                          fontSize: isCurrent ? 20 : 16,
                        ),
                      ),
                    ),
                  ),
                  // Tick if completed
                  if (isComplete)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white70,
                      size: 30,
                    ),
                ],
              ),
              // Progress line
              if (idx < totalLevels - 1)
                Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: isComplete ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
