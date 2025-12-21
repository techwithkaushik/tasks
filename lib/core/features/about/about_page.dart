import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String title;
  const AboutPage(this.title, {super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
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
      ),
    );
  }
}
