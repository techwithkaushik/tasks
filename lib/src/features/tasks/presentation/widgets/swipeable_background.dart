import 'package:flutter/material.dart';

class SwipeableBackground extends StatelessWidget {
  final double progress;
  final Alignment alignment;
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;

  const SwipeableBackground({
    super.key,
    required this.progress,
    required this.alignment,
    required this.backgroundColor,
    required this.iconData,
    required this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: alignment,
      heightFactor: 1,
      widthFactor: progress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: ColoredBox(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Icon(iconData, color: iconColor),
          ),
        ),
      ),
    );
  }
}
