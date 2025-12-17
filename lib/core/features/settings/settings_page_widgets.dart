import 'package:flutter/material.dart';

class AppSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;

  /// If provided, tile becomes a Switch tile.
  final bool? value;
  final ValueChanged<bool>? onChanged;

  /// For action-type tiles (language, privacy etc.)
  final VoidCallback? onTap;

  const AppSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.value,
    this.onChanged,
    this.onTap,
  });

  bool get hasSwitch => value != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // If it's a switch tile → toggle the switch when tile is tapped
        if (hasSwitch) {
          onChanged!(!value!);
        } else {
          // Otherwise perform action
          onTap?.call();
        }
      },

      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT SIDE
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 16),
                    child: Icon(icon),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (description != null && description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // RIGHT SIDE: switch or arrow
            if (hasSwitch)
              Switch(value: value!, onChanged: onChanged)
            else if (onTap != null)
              Container(),
          ],
        ),
      ),
    );
  }
}
