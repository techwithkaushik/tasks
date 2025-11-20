import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/services/snackbar_service.dart';
import 'package:tasks/models/task_model.dart';
import 'package:tasks/services/auth_service.dart';
import 'package:intl/intl.dart';

class AddEditController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final RxnString _titleError = RxnString();
  final RxnString _contentError = RxnString();

  String? get titleError => _titleError.value;
  String? get contentError => _contentError.value;

  set titleError(String? s) => _titleError.value = s;
  set contentError(String? s) => _contentError.value = s;

  final RxString _whenComplete = "".obs;
  String get whenComplete => _whenComplete.value;
  set whenComplete(String d) => _whenComplete.value = d;

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isWhenComplete = false.obs;
  final RxBool isWhenCompleteError = false.obs;

  String taskDocId = "";

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void checkTitleField() {
    titleError = titleController.text.isEmpty ? "enter title" : null;
  }

  void checkContentField() {
    contentError = contentController.text.isEmpty ? "enter content" : null;
  }

  /// Format with seconds always
  String generateTimeWithSeconds(DateTime d) {
    return DateFormat("yyyy-MM-dd hh:mm:ss a").format(d);
  }

  void saveTask() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    checkTitleField();
    checkContentField();
    if (titleError != null || contentError != null) return;

    if (isWhenComplete.value && whenComplete.isEmpty) {
      isWhenCompleteError.value = true;
      return;
    }

    isLoading.value = true;

    try {
      final user = AuthService().currentUser;
      if (user == null) {
        SnackbarService.show(
          title: 'Not logged in',
          message: 'Please login to save tasks',
          isError: true,
        );
        isLoading.value = false;
        return;
      }

      final collection = FirebaseFirestore.instance.collection("tasks");

      final String finalWhenComplete = isWhenComplete.value ? whenComplete : "";

      if (!isEditing.value) {
        /// NEW TASK
        final task = Task(
          userId: user.uid,
          title: title,
          content: content,
          whenComplete: finalWhenComplete,
          isCompleted: false,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        collection.add(task.toFirestore());
      } else {
        /// EDITING EXISTING
        collection.doc(taskDocId).update({
          'title': title,
          'content': content,
          'whenComplete': finalWhenComplete,
          'updatedAt': Timestamp.now(),
        });
      }

      SnackbarService.show(
        title: isEditing.value ? 'Task Updated' : 'Task Saved',
        message: isEditing.value
            ? 'Task "$title" updated'
            : 'New task "$title" added',
        duration: const Duration(seconds: 2),
      );

      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      SnackbarService.show(
        title: 'Save Failed',
        message: e.toString(),
        isError: true,
      );
    }
  }
}
