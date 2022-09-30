// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/components/CustomProgressIndicator.dart';
import 'package:upasthit/services/admin_services.dart';

import '../../providers/admin_provider.dart';
import 'admin_screen.dart';

class AllMemberScreen extends StatefulWidget {
  const AllMemberScreen({Key? key}) : super(key: key);

  @override
  State<AllMemberScreen> createState() => _AllMemberScreenState();
}

class _AllMemberScreenState extends State<AllMemberScreen> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    List<MemberCard> memberCards=Provider.of<AdminProvider>(context).getMembers;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members Status"),
      ),
      body:!isLoading?SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: memberCards.length,
                itemBuilder: (itemBuilder,index){
                  var item=memberCards[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 280,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    itemBuilderCol(item.info['name'],Icons.person,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text("Approved", style: TextStyle(fontSize: 20,color: Colors.white),),
                                        Transform.scale(
                                            scale: 1,
                                            child: Switch(
                                              onChanged: (value) async {
                                                setState(() {
                                                  isLoading=true;
                                                });
                                               try{
                                                 if (kDebugMode) {
                                                   print('here');
                                                 }
                                                 if(value)
                                                 {
                                                   await AdminServices.acceptReq(id: item.uid);
                                                 }
                                                 else{
                                                   await AdminServices.rejectReq(id: item.uid);

                                                 }
                                                 await Provider.of<AdminProvider>(context,listen: false).fetchMembersData;
                                               }catch(e){
                                                 log(e.toString());
                                                 Fluttertoast.showToast(msg: "Something went wrong");
                                               }finally{
                                                 setState(() {
                                                   isLoading=false;
                                                 });
                                               }
                                              },
                                              value: item.status??false,
                                              activeColor: Colors.blue,
                                              activeTrackColor: Colors.yellow,
                                              inactiveThumbColor: Colors.redAccent,
                                              inactiveTrackColor: Colors.orange,
                                            )
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                itemBuilderCol(item.info['em'],Icons.email,),
                                itemBuilderCol(item.info['phno']??"Not Available",Icons.phone,),
                                itemBuilderCol(item.info['address']??"Not Available",Icons.location_city_outlined,),


                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

            ),
          ],
        ),
      ):const Center(child: CustomProgressIndicator(msg: "Loading",),),
    );
  }
  Widget itemBuilderCol(txt,IconData icon){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon,color: Colors.white,),
          const SizedBox(width: 10,),
          Text(txt,style: const TextStyle(
              color: Colors.white,
              fontSize: 14
          ),)
        ],
      ),
    );
  }
}
