import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tasks/src/features/tasks/data/models/task_model.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

class TaskFirestoreDataSource {
  FirebaseFirestore firestore;
  TaskFirestoreDataSource({required this.firestore});
  CollectionReference get _ref => firestore.collection("tasks");

  Stream<List<Task>> loadTasks(String userId) => _ref
      .where("userId", isEqualTo: userId)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map(_parseTaskSnapshot);

  /// A single legacy or malformed document must not break the entire task
  /// stream. Valid documents continue to be delivered; invalid documents are
  /// skipped until they are repaired in Firestore.
  List<Task> _parseTaskSnapshot(QuerySnapshot snapshot) {
    final tasks = <Task>[];
    for (final doc in snapshot.docs) {
      try {
        tasks.add(TaskModel.fromDoc(doc).toEntity(doc.id));
      } on Object {
        // Ignore only this document; other valid tasks remain available.
      }
    }
    return tasks;
  }

  Future<void> addTask(Task task) => _ref.add(task.toJson());

  Future<void> updateTask(Task task) => _ref.doc(task.id).update(task.toJson());

  Future<void> deleteTask(String id) => _ref.doc(id).delete();
}
