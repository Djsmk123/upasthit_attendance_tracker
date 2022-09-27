import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/users_models.dart';
import '../models/attendance_model.dart';
import '../services/firebase_services.dart';

class AttendanceProvider with ChangeNotifier{
  List<AttendanceModel> attendanceModel=[];
  get getAttendanceModel=>attendanceModel;
  VolModel model=VolModel();
  get getVolModel=>model;
  update(uid) async {
    var doc=await FirebaseService.getVolunteerData(uid: uid);
    model.info=doc.get('info');
    List db=doc.get('attendance');
    attendanceModel.clear();
    for (var element in db) {
      attendanceModel.add(AttendanceModel.fromJson(element));
    }
    attendanceModel.sort((a,b)=>a.date!.compareTo(b.date!));
    notifyListeners();
  }
  addAttendance({required Timestamp date,required String status}){
    attendanceModel.add(AttendanceModel.fromJson({
      'Date':date,
      "status":status

    }));
    attendanceModel.sort((a,b)=>a.date!.compareTo(b.date!));
    notifyListeners();
  }


}