// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/Models/users_models.dart';
import 'package:upasthit/components/CustomProgressIndicator.dart';
import 'package:upasthit/constants.dart';
import 'package:upasthit/models/attendance_model.dart';
import 'package:upasthit/providers/attendance_provider.dart';

import '../../services/firebase_services.dart';
import '../../services/logins_signup_services.dart';
import '../attandance_builder.dart';
import '../welcome_screen.dart';

class VolScreen extends StatefulWidget {
  const VolScreen({Key? key}) : super(key: key);

  @override
  State<VolScreen> createState() => _VolScreenState();
}

class _VolScreenState extends State<VolScreen> {
  bool isLoading=true;


  initAsync()async {
    try{
      Provider.of<AttendanceProvider>(context,listen: false).update(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading=false;
      });
    }catch(e){
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AttendanceProvider>(context,listen: false).attendanceModel.clear();
    Provider.of<AttendanceProvider>(context,listen: false).model=VolModel();
    initAsync();
  }
  @override
  Widget build(BuildContext context) {
    final List<AttendanceModel> attendanceModel=Provider.of<AttendanceProvider>(context).getAttendanceModel;
    final VolModel model=Provider.of<AttendanceProvider>(context).getVolModel;
    if (!isLoading) {
      return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Authentication().logOut().then((value) {
                  setState((){
                    isLoading=true;
                  });
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (builder)=>const WelcomeScreen()));
                }).catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
              ))
        ],
        leading:const Padding(
          padding:  EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("assets/images/volunteer-icon.png"),
            radius: 20,
          ),
        ),
        elevation: 10,
        title: Text(
            "HI,${model.info['name']}",
      ),
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            children: [
              AttendanceBuilder(id: FirebaseAuth.instance.currentUser!.uid,isMember:false)

            ],
          ),
        )
      ),
    );
    } else {
      return const Scaffold(
      body: Center(
          child:CircularProgressIndicator()
      ),
    );
    }
  }
}

