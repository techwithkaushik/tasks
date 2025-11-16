import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/add_edit_controller.dart';

class AddEditTaskPage extends StatelessWidget {
  AddEditTaskPage({super.key});
  final AddEditController controller = Get.put(AddEditController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text("AddEditTask")),
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
                        var currentDateTime = DateTime.now();
                        var selectedDate = DateTime(
                          currentDateTime.year,
                          currentDateTime.month,
                          currentDateTime.day,
                          currentDateTime.hour,
                          currentDateTime.minute,
                        );

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.input,
                          firstDate: selectedDate,
                          lastDate: DateTime(2050),
                          initialDate: selectedDate,
                        );

                        if (pickedDate == null) return;
                        if (!context.mounted) return;

                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.input,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );

                        if (pickedTime == null) return;

                        controller.whenComplete =
                            DateFormat("yyyy-MM-dd hh:mm a").format(
                              DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              ),
                            );
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                    Text("When complete? ${controller.whenComplete}"),
                  ],
                ),
                SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () => controller.saveTask(),
                  child: controller.isLoading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text("save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
