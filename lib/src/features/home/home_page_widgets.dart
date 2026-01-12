import 'package:flutter/material.dart';

class AnimatedBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final int count;
  const AnimatedBadge({
    super.key,
    required this.color,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            left: 20,
            top: -4,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Container(
                key: ValueKey(count),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(minHeight: 18, minWidth: 18),
                child: Text(
                  count > 99 ? "99+" : "$count",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
