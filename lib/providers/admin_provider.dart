import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:upasthit/models/collection.dart';
import 'package:upasthit/services/admin_services.dart';

class AdminProvider extends ChangeNotifier{
  bool isLoading=true;
  get getLoadingStatus=>isLoading;
  QuerySnapshot<Map<String,dynamic>>? memberData;
  QuerySnapshot<Map<String,dynamic>>? volunteerData;
  QuerySnapshot<Map<String, dynamic>>? get getVolunteerData=>volunteerData;

  fetchVolunteerData()async{
    var doc=await Collections().userData.get();
    volunteerData=doc;
    notifyListeners();
  }

  set setLoading(value){
    isLoading=value;
    notifyListeners();
  }
  
  get getMemberData=>memberData;
  
  
  get setMemberData async {
    memberData=await AdminServices.getMembersData();
    notifyListeners();
  }

  List<Map<String,dynamic >> get nonApproveMember{
    List<Map<String,dynamic>> members=[];
    if(memberData!=null){
      for(var i in memberData!.docs)
        {
          bool? isApprove;
          if(i.data().containsKey('isApproved'))
            {
              isApprove=i.get('isApproved');
            }
          if(isApprove==null)
            {
              var tmp=i.data();
              tmp['id']=i.id;
              members.add(tmp);
            }
        }
    }
    return members;
  }
  

}