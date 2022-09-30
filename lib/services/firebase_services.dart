import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upasthit/models/collection.dart';

import '../models/attendance_model.dart';

class FirebaseService{
  static String razorPayKey="rzp_test_T1BsVQXMJ3Sfup";
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

  static addDonation({required double amount,required String csName,required String transactionId,required String uid}) async {
    await Collections().userData.doc(uid).update({
      'donations':FieldValue.arrayUnion([{
        'Amount':amount,
        'Customer Name':csName,
        'Date':Timestamp.now(),
        'To':"Teens of God(NGO)",
        'transactionId':transactionId
      }])
    });
  }

  static isApproved({required String uid})async {
   var doc= await Collections().member.doc(uid).get();
   var tmp=doc.data();
   if(tmp!.containsKey('isApproved'))
     {
       return tmp['isApproved'];
     }
   return false;
  }
}
