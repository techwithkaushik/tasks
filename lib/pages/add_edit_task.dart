import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/add_edit_controller.dart';
import 'package:tasks/models/task_model.dart';

class AddEditTaskPage extends StatelessWidget {
  AddEditTaskPage({super.key});
  final AddEditController controller = Get.put(AddEditController());
  final args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    if (args != null) {
      final Task editingTask = args['task'];
      controller.isEditing.value = true;
      controller.taskDocId = editingTask.docId!;
      controller.titleController.text = editingTask.title;
      controller.contentController.text = editingTask.content;
      if (editingTask.whenComplete != null &&
          editingTask.whenComplete!.isNotEmpty) {
        controller.whenComplete = editingTask.whenComplete!;
        controller.isWhenComplete.value = true;
      }
    }
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.isEditing.value ? "Update Task" : "Add Task"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    label: Text("Title"),
                    errorText: controller.titleError,
                  ),
                  onChanged: (value) => controller.checkTitleField(),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: controller.contentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    label: Text("Content"),
                    errorText: controller.contentError,
                  ),
                  onChanged: (value) => controller.checkContentField(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        var initial = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        );

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: initial,
                          lastDate: DateTime(2050),
                          initialDate: initial,
                        );

                        if (pickedDate == null) return;
                        if (!context.mounted) return;

                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(initial),
                        );

                        if (pickedTime == null) return;

                        /// ADD SECONDS FIXED
                        final full = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                          DateTime.now().second,
                        );

                        controller.whenComplete = DateFormat(
                          "yyyy-MM-dd hh:mm:ss a",
                        ).format(full);

                        controller.isWhenComplete.value = true;
                        controller.isWhenCompleteError.value = false;
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                    Column(
                      children: [
                        Text("When complete?"),
                        Text(": ${controller.whenComplete}"),
                      ],
                    ),
                    Checkbox(
                      isError: controller.isWhenCompleteError.value,
                      value: controller.isWhenComplete.value,
                      onChanged: ((value) {
                        controller.isWhenComplete.value = value!;
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () => controller.saveTask(),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(controller.isEditing.value ? "Update" : "Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
