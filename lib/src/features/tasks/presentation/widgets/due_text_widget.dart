import 'package:flutter/material.dart';

class DueTextWidget extends StatelessWidget {
  final DateTime? due;
  const DueTextWidget({super.key, required this.due});

  @override
  Widget build(BuildContext context) {
    if (due == null) return const Text("No due date");

    return StreamBuilder<int>(
      key: ValueKey(due),
      stream: Stream.periodic(const Duration(seconds: 1), (x) => x),
      builder: (_, _) {
        final now = DateTime.now();
        final us = due!.difference(now).inMicroseconds;

        final secs = (us / 1e6).floor();

        TextStyle style = DefaultTextStyle.of(context).style;

        if (secs < 0) {
          final overdueSecs = -secs;
          final days = overdueSecs ~/ 86400;
          final hours = (overdueSecs % 86400) ~/ 3600;
          final minutes = (overdueSecs % 3600) ~/ 60;
          final seconds = overdueSecs % 60;

          style = style.copyWith(color: Theme.of(context).colorScheme.error);

          if (days > 0) {
            return Text("Overdue by $days d $hours h", style: style);
          }
          if (hours > 0) {
            return Text("Overdue by $hours h $minutes m", style: style);
          }
          if (minutes > 0) {
            return Text("Overdue by $minutes m $seconds s", style: style);
          }
          return Text("Overdue by $seconds s", style: style);
        }

        if (secs == 0) {
          return Text(
            "Due now",
            style: style.copyWith(
              color: Theme.of(context).colorScheme.errorContainer,
            ),
          );
        }

        if (secs < 3600) {
          final minutes = secs ~/ 60;
          final seconds = secs % 60;

          style = style.copyWith(
            color: Theme.brightnessOf(context) == Brightness.dark
                ? Colors.orangeAccent
                : Colors.deepOrangeAccent,
          );

          if (minutes > 0) {
            return Text("Due soon in $minutes m $seconds s", style: style);
          }
          return Text("Due soon in $seconds s", style: style);
        }

        final days = secs ~/ 86400;
        final hours = (secs % 86400) ~/ 3600;
        final minutes = (secs % 3600) ~/ 60;

        style = style.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        );

        if (days > 0) return Text("Due in $days d $hours h", style: style);
        if (hours > 0) return Text("Due in $hours h $minutes m", style: style);
        return Text("Due in $minutes m");
      },
    );
  }
}
