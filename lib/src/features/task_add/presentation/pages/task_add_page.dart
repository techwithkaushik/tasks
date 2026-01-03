import 'package:flutter/material.dart';
import 'package:tasks/l10n/app_localizations.dart';

class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.addTask)),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l.title,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: l.content,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(l.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
