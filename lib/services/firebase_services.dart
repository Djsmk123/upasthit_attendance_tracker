import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upasthit/models/collection.dart';

import '../models/attendance_model.dart';

class FirebaseService{
  static Collections collection=Collections();
  static Future<DocumentSnapshot> getVolunteerData({required String uid}) async {
    var doc=await collection.userData.doc(uid).get();
    return doc;
  }
  static getMemberData({required String uid}) async {
    var doc=await collection.member.doc(uid).get();
    return doc;
  }
  static updateAttendance({required List<AttendanceModel> attendanceModel,required String volId}) async {
    for (var element in attendanceModel) {
      await collection.userData.doc(volId).update({
      'attendance':FieldValue.arrayUnion([{
        'Date':element.date,
        'status':element.status
      }])
      });
    }

  }

  static get getAllMemberAttendance async {
    var doc=await collection.userData.get();
    return doc.docs;
  }


}