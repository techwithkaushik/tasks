import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    return date == null ? null : Timestamp.fromDate(date);
  }
}
