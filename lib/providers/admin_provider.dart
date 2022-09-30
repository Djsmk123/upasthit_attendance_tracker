import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:upasthit/models/collection.dart';
import 'package:upasthit/services/admin_services.dart';

import '../screens/admin/admin_screen.dart';

class AdminProvider extends ChangeNotifier{
  bool isLoading=true;
  get getLoadingStatus=>isLoading;
  List<VolunteerCard> volunteerCards=[];
  List<MemberCard> memberCards=[];
  List<MemberCard> nonApprovedMembers=[];
  get fetchMembersData async{
    var doc=await Collections().member.get();
    nonApprovedMembers.clear();
    memberCards.clear();
    for(var element in doc.docs)
      {
        var tmp=element.data();
        if(tmp['isApproved']==null)
          {
            nonApprovedMembers.add(MemberCard(info: tmp['info'], uid:element.id, status: null));
          }
        memberCards.add(MemberCard(info: tmp['info'], uid: element.id, status: tmp['isApproved']));
      }
    notifyListeners();
  }

  set setLoading(value){
    isLoading=value;
    notifyListeners();
  }

  
  
  get fetchVolunteerData async {
    var memberData=await Collections().userData.get();
    volunteerCards.clear();
    for(var elements in memberData.docs)
      {
        var tmp=elements.data();
        List att=[];
        List donation=[];
        if(tmp['donations']!=null) {
          donation.addAll(tmp['donations']);
        }
        if(tmp['attendance']!=null) {
          att.addAll(tmp['attendance']);
        }
        volunteerCards.add(VolunteerCard(attendance: att, donations: donation, info: tmp['info'], uid: elements.id));
      }
    notifyListeners();
  }

 get getNonApprovedMember=>nonApprovedMembers;
  get getMembers=>memberCards;
  get getVolunteers=>volunteerCards;
  

}