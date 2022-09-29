import 'package:upasthit/models/collection.dart';

class AdminServices{
  static getMembersData() async {
    var doc=await Collections().member.get();
    return doc;
  }
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