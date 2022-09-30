// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/Models/users_models.dart';
import 'package:upasthit/components/rounded_button.dart';
import 'package:upasthit/components/transcation_screen.dart';
import 'package:upasthit/models/attendance_model.dart';
import 'package:upasthit/providers/admin_provider.dart';
import 'package:upasthit/providers/attendance_provider.dart';
import 'package:upasthit/screens/attendace_components/attendance_view_screen.dart';


import 'admin_screen.dart';

class AllVounteerScreen extends StatefulWidget {
   
  const AllVounteerScreen({Key? key}) : super(key: key);

  @override
  State<AllVounteerScreen> createState() => _AllVounteerScreenState();
}

class _AllVounteerScreenState extends State<AllVounteerScreen> {
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    List<VolunteerCard> volunteers=Provider.of<AdminProvider>(context).getVolunteers;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer status",style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: volunteers.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (itemBuilder,index){
                  var item=volunteers[index];
                  VolModel model=VolModel();
                  model.info=item.info;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 230,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                            color: Colors.blueAccent.shade700,
                            borderRadius: BorderRadius.circular(16)
                          ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person,color: Colors.white,),
                                      const SizedBox(width: 10,),
                                      Text(model.info['name'],style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14
                                      ),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.email,color: Colors.white,),
                                      const SizedBox(width: 10,),
                                      Text(model.info['em'],style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone,color: Colors.white,),
                                      const SizedBox(width: 10,),
                                      Text("+91 "+model.info['phno'].toString(),style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Bounce(

                                        duration: const Duration(milliseconds: 200),
                                        onPressed: () {
                                          Provider.of<AttendanceProvider>(context,listen: false).attendanceModel.clear();
                                          List<AttendanceModel> att=[];
                                          for(var i in item.attendance)
                                          {
                                            att.add(AttendanceModel.fromJson(i));
                                          }
                                          Provider.of<AttendanceProvider>(context,listen: false).attendanceModel.addAll(att);
                                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>AttendanceViewScreen(id: item.uid,isMember: true,)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16)
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Text("Attendance"),
                                        ),
                                      ),
                                      Bounce(
                                        onPressed:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>TranscationScreen(donations: item.donations)));
                                        },
                                        duration: Duration(milliseconds: 200),

                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Text("Donation"),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
