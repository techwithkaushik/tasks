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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 18),
      onTap: () {
        if (hasSwitch) {
          onChanged!(!value!);
        } else {
          onTap?.call();
        }
      },
      leading: Icon(icon),
      trailing: hasSwitch
          ? Switch(value: value!, onChanged: onChanged)
          : SizedBox.shrink(child: Text("no ontap")),
      title: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        description!,
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
    );
  }
}
