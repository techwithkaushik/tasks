import 'package:flutter/material.dart';

Widget appSettings({
  required IconData icon,
  required String title,
  required String descreption,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5, right: 15),
        child: Icon(icon),
      ),
      Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(descreption, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
      Switch(value: value, onChanged: onChanged),
    ],
  );
}
