import 'package:flutter/material.dart';
import 'package:tasks/src/features/about/about_content_page.dart';

class AboutPage extends StatelessWidget {
  final String title;
  const AboutPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: AboutContentPage(),
    );
  }
}
