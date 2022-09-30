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
import 'package:upasthit/screens/attendace_components/attendance_view_screen.dart';

import '../../services/logins_signup_services.dart';

import '../welcome_screen.dart';
import 'donation_screen.dart';

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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
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
      endDrawer: Drawer(
        child: Column(
          children:  [
            const SizedBox(height: 50,),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/volunteer-icon.png"),
            ),
            const SizedBox(height: 10,),
             Center(
              child: Text(model.info['name'],style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
            ),
            const Divider(
              thickness: 2,
              height: 20,
            ),
            drawerTile(Icons.event_note_sharp,"Attendance Record",(){
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>AttendanceViewScreen(id: FirebaseAuth.instance.currentUser!.uid, isMember: false)));
            }),
            drawerTile(Icons.receipt,"Donation Record",(){
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>DonationScreen()));
            }),
            drawerTile(Icons.logout, "Logout", () async {
              setState((){
                isLoading=true;
              });
              try{
                await Authentication().logOut();
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                    context, MaterialPageRoute(builder: (builder)=>const WelcomeScreen()));
              }catch(e){
                Fluttertoast.showToast(msg: "Something went wrong");
                setState((){
                  isLoading=false;
                });
              }
            })
          ],
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
              const SizedBox(height: 20,)
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
  Widget drawerTile(IconData icn,String txt,GestureTapCallback onTap){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Flexible(child: ListTile(
            leading: Icon(icn),
            horizontalTitleGap: 5,
            title: Text(txt,style: const TextStyle(
             color: Colors.black,
              fontSize:  20
        ),),
        ))
          ],
        ),
      ),
    );
  }
}

