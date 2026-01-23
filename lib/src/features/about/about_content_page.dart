import 'package:flutter/material.dart';

class AboutContentPage extends StatelessWidget {
  const AboutContentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => LicensePage()));
            },
            child: Text("License"),
          ),
        ],
      ),
    );
  }
}
