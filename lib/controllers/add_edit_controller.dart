import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/models/task_model.dart';
import 'package:tasks/services/auth_service.dart';

class AddEditController extends GetxController {
  // FIXED: No .obs() on TextEditingController
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

  void checkTitleField() {
    titleError = titleController.text.isEmpty ? "enter title" : null;
  }

  void checkContentField() {
    contentError = contentController.text.isEmpty ? "enter content" : null;
  }

  void saveTask() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    // Basic validation
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
        isLoading.value = false;
        // optional: show login required snackbar
        Get.snackbar(
          "Not logged in",
          "Please login to save tasks",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      final CollectionReference collection = FirebaseFirestore.instance
          .collection("tasks");
      if (!isEditing.value) {
        final task = Task(
          userId: user.uid,
          title: title,
          content: content,
          whenComplete: whenComplete,
          isCompleted: false,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        // Example using add()
        collection.add(task.toFirestore());
      } else {
        // Example using set() with options (if you prefer update, use update)
        collection.doc(taskDocId).set({
          'title': title,
          'content': content,
          'whenComplete': isWhenComplete.value ? whenComplete : "",
          'updatedAt': Timestamp.now(),
        }, SetOptions(merge: true));
      }
      Get.showSnackbar(
        GetSnackBar(
          title: isEditing.value ? "Task Updated" : "Task Saved",
          message: isEditing.value
              ? "Task \"$title\" updated"
              : "New task \"$title\" added",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(
            seconds: 2,
          ), // visible time for success message
          isDismissible: true,
          showProgressIndicator: true,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
          snackStyle: SnackStyle.FLOATING,
        ),
      );
      Get.back(closeOverlays: true);
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Save Failed",
          message: e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          isDismissible: true,
          margin: const EdgeInsets.all(12),
          showProgressIndicator: true,
          borderRadius: 8,
          snackStyle: SnackStyle.FLOATING,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
