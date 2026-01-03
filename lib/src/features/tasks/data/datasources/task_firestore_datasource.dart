import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/src/features/tasks/data/models/task_model.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

class TaskFirestoreDataSource {
  final _ref = FirebaseFirestore.instance.collection("tasks");

  Stream<List<Task>> watchTasks() => _ref
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((s) => s.docs.map(TaskModel.fromDoc).toList());

  Future<void> addTask(Task task) => _ref.add(TaskModel.toJson(task));

  Future<void> updateTask(Task task) =>
      _ref.doc(task.id).update(TaskModel.toJson(task));

  Future<void> deleteTask(String id) => _ref.doc(id).delete();
}
