import 'package:upasthit/models/collection.dart';

class AdminServices{
  static acceptReq({required String id})async{
    await Collections().member.doc(id).update({
      'isApproved':true,
    });
  }
  static rejectReq({required String id}) async{
    await Collections().member.doc(id).update({
      'isApproved':false,
    });
  }



}