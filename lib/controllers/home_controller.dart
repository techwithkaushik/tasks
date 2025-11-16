import 'dart:async';

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
  final Rx<DateTime> _now = DateTime.now().obs;
  late Timer _timer;
  get currentTime {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _now.value = DateTime.now();
    });
    return _now.value;
  }

  String _relativeFrom(Duration d) {
    final seconds = d.inSeconds.abs();
    // seconds (show seconds only)
    if (seconds < 60) return '${seconds}s';

    final minutes = d.inMinutes.abs();
    // minutes + seconds (e.g. "2m 5s")
    if (minutes < 60) {
      final secPart = seconds % 60;
      return secPart > 0 ? '${minutes}m ${secPart}s' : '${minutes}m';
    }

    final hours = d.inHours.abs();
    // hours + minutes (e.g. "3h 15m")
    if (hours < 24) {
      final minPart = minutes % 60;
      return minPart > 0 ? '${hours}h ${minPart}m' : '${hours}h';
    }

    final days = d.inDays.abs();
    // days + hours (e.g. "1d 4h")
    if (days < 7) {
      final hourPart = hours % 24;
      return hourPart > 0 ? '${days}d ${hourPart}h' : '${days}d';
    }

    final weeks = (days / 7).floor();
    // weeks + days (e.g. "2w 3d") — keep showing weeks up to a few
    if (weeks < 5) {
      final dayPart = days % 7;
      return dayPart > 0 ? '${weeks}w ${dayPart}d' : '${weeks}w';
    }

    // fallback: days
    return '${days}d';
  }

  String relativeToNow(DateTime target) {
    final diff = target.difference(currentTime);
    if (diff.inSeconds > 0) return 'in ${_relativeFrom(diff)}';
    return '${_relativeFrom(diff)} ago';
  }

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void loadTasks() {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.offAllNamed(RouteNames.getLoginPage());
        return;
      }
      FirebaseFirestore.instance
          .collection("tasks")
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

      FirebaseFirestore.instance.collection("tasks").doc(task.docId).update({
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
      FirebaseFirestore.instance.collection("tasks").doc(task.docId).delete();
    } catch (e) {
      Get.snackbar("Failed Delete", e.toString());
    }
  }
}
