import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<AttendanceModel> attendanceModelFromJson(String str) => List<AttendanceModel>.from(json.decode(str).map((x) => AttendanceModel.fromJson(x)));

String attendanceModelToJson(List<AttendanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
/*final attendanceModel = attendanceModelFromJson(jsonString);*/
class AttendanceModel {
  AttendanceModel({
    required this.date,
    required this.status,
  });

  Timestamp? date;
  String? status;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    date: json["Date"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "Date": date,
    "status": status,
  };
}