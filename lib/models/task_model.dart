import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? docId;
  String userId;
  String title;
  String content;
  String? whenComplete;
  bool? isCompleted;
  Timestamp? completedAt;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Task({
    this.docId,
    required this.userId,
    required this.title,
    required this.content,
    this.whenComplete,
    this.isCompleted,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a Task from a Firestore document-like object. We accept `dynamic`
  /// here so tests don't need to import firebase packages; the doc's fields
  /// may be `DateTime` or `Timestamp` (from Firestore). We normalize to
  /// `DateTime?`.
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data()) as Map<String, dynamic>;

    return Task(
      docId: doc.id,
      userId: data["userId"] ?? "",
      title: data["title"] ?? "",
      content: data["content"] ?? "",
      whenComplete: data["whenComplete"] ?? "",
      isCompleted: data["isCompleted"] ?? false,
      completedAt: data["completedAt"] as Timestamp?,
      createdAt: data["createdAt"] as Timestamp?,
      updatedAt: data["updatedAt"] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "title": title,
      "content": content,
      "whenComplete": whenComplete,
      "isCompleted": isCompleted,
      "completedAt": completedAt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
