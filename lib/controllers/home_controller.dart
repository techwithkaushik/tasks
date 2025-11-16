import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tasks/models/task_model.dart';
import 'package:tasks/routes/route_names.dart';

class HomeController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;

  final RxBool _isLoading = true.obs;
  get isLoading => _isLoading.value;
  set isLoading(bool b) => _isLoading.value = b;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  final taskCollection = FirebaseFirestore.instance.collection("tasks");

  void loadTasks() {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.offAllNamed(RouteNames.getLoginPage());
        return;
      }
      taskCollection
          .where("userId", isEqualTo: uid)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .listen((snapshot) {
            tasks.value = snapshot.docs
                .map((doc) => Task.fromFirestore(doc))
                .toList();
            isLoading = false;
          });
    } catch (e) {
      Get.snackbar("Failed loadTasks", e.toString());
    }
  }

  void updateTask(int index, bool isCompleted) {
    try {
      final task = tasks.elementAt(index);
      if (task.isCompleted!) {
        task.completedAt = Timestamp.now();
      } else {
        task.completedAt = null;
      }

      taskCollection.doc(task.docId).update({
        "isCompleted": isCompleted,
        "updatedAt": Timestamp.now(),
        if (isCompleted)
          "completedAt": Timestamp.now()
        else
          "completedAt": null,
      });
    } catch (e) {
      Get.snackbar("Failed Update", e.toString());
    }
  }

  void deleteTask(int index) {
    try {
      final task = tasks.elementAt(index);
      taskCollection.doc(task.docId).delete();
    } catch (e) {
      Get.snackbar("Failed Delete", e.toString());
    }
  }
}
