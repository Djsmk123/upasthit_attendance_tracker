// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:developer';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/Models/users_models.dart';
import 'package:upasthit/components/FadeAnimation.dart';
import 'package:upasthit/components/id_card.dart';
import 'package:upasthit/components/rounded_button.dart';
import 'package:upasthit/providers/attendance_provider.dart';
import 'package:upasthit/screens/attendace_components/attandance_builder.dart';

import '../../services/logins_signup_services.dart';

import '../welcome_screen.dart';

class VolScreen extends StatefulWidget {
  const VolScreen({Key? key}) : super(key: key);

  @override
  State<VolScreen> createState() => _VolScreenState();
}

class _VolScreenState extends State<VolScreen> {
  bool isLoading=true;
  final GlobalKey _globalKey = GlobalKey();
  Future<Uint8List?> capturePng() async {
    try {
      var boundary = _globalKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
      ui.Image? image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

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
              RepaintBoundary(
                  key: _globalKey,
                  child: IdCardWidget(model,context,true)),
              FadeAnimation(
                1.2,
                RoundedButton(text: "Download",
                  press: () async {
                  final bytes = await capturePng();
                  showDialog(context: context, builder: (builder){
                    return AlertDialog(
                      title:const Text("Generated ID CARD"),
                      content: Image.memory(bytes!),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel",style: TextStyle(
                              fontSize: 16
                          ),),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var msg="Successfully Downloaded";
                            try{
                              await ImageGallerySaver.saveImage(bytes,name: "qr_code_${model.info['name']}");
                              Fluttertoast.showToast(msg: msg);
                              Navigator.pop(context);
                            }catch(e){
                              msg="Something went wrong";
                              Fluttertoast.showToast(msg: msg);
                              log(e.toString());
                            }



                          },
                          child: const Text("Save",style: TextStyle(
                            fontSize: 16
                          ),),
                        )
                      ],

                    );
                  });

                },color: Colors.blueAccent,),
              ),
              const SizedBox(height: 20,),
              AttendanceBuilder(id: FirebaseAuth.instance.currentUser!.uid,isMember:false),

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

