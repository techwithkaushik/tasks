import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/models/task_model.dart';
import 'package:tasks/services/auth_service.dart';

class AddEditController extends GetxController {
  TextEditingController titleController = TextEditingController().obs();
  TextEditingController contentController = TextEditingController().obs();

  final RxnString _titleError = RxnString();
  final RxnString _contentError = RxnString();

  get titleError => _titleError.value;
  get contentError => _contentError.value;

  set titleError(String? s) => _titleError.value = s;
  set contentError(String? s) => _contentError.value = s;

  final RxString _whenComplete = "".obs;
  get whenComplete => _whenComplete.value;
  set whenComplete(String d) => _whenComplete.value = d;

  final RxBool _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(bool b) => _isLoading.value = b;

  void checkTitleField() {
    var title = titleController.text;
    titleError = null;
    if (title.isEmpty) {
      titleError = "enter title";
      return;
    }
  }

  void checkContentField() {
    var content = contentController.text;
    contentError = null;
    if (content.isEmpty) {
      contentError = "enter content";
      return;
    }
  }

  void saveTask() {
    var title = titleController.text;
    var content = contentController.text;

    isLoading = true;
    if (title.isEmpty || content.isEmpty) {
      checkTitleField();
      checkContentField();
      isLoading = false;
      return;
    }

    try {
      User? user = AuthService().currentUser;

      if (user == null) {
        isLoading = false;
        return;
      }

      Task task = Task(
        userId: user.uid,
        title: title,
        content: content,
        whenComplete: whenComplete,
        isCompleted: false,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      FirebaseFirestore.instance.collection("tasks").add(task.toFirestore());
      Get.snackbar(
        "Task Saved",
        "New task ${task.title} added",
        snackPosition: SnackPosition.BOTTOM,
      );
      whenComplete = "";
    } catch (e) {
      Get.snackbar(
        "Task failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoading = false;
    titleController.text = "";
    contentController.text = "";
  }
}
