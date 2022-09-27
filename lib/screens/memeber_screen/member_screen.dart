// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:upasthit/constants.dart';
import 'package:upasthit/providers/attendance_provider.dart';

import '../../Models/users_models.dart';
import '../../models/attendance_model.dart';
import '../../services/logins_signup_services.dart';
import '../attandance_builder.dart';
import '../welcome_screen.dart';

/*@override
void reassemble() {
  super.reassemble();
  if (Platform.isAndroid) {
    controller!.pauseCamera();
  } else if (Platform.isIOS) {
    controller!.resumeCamera();
  }
}*/



class _MemberScreenState extends State<MemberScreen> {
  bool isLoading=false;
  Barcode? result;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
  setState(() => this.controller = controller);
  controller.resumeCamera();
  controller.scannedDataStream.listen((scanData) {
  setState(() => result = scanData);
  });
  }
  bool isScanned=false;
  bool isScanning=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void readQr() async {
    if (result != null) {
      controller!.pauseCamera();
      setState(() {
        isLoading=true;
        isScanning=false;
      });
      try{
        await Provider.of<AttendanceProvider>(context,listen: false).update(result!.code.toString());
        isScanned=true;
      }

      catch(e){
        log(e.toString());
      }
      setState(() {
        isLoading=false;
      });

      controller!.dispose();
    }
  }
  @override

  void dispose() {
    //controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final List<AttendanceModel> attendanceModel=Provider.of<AttendanceProvider>(context).getAttendanceModel;
    final VolModel model=Provider.of<AttendanceProvider>(context).getVolModel;
    if(isScanning)
      readQr();
    return WillPopScope(

      onWillPop: ()async {
        if(isScanning)
          {
            setState(() {
              isScanning=false;
            });
            //controller!.dispose();
            return false;
          }
        return true;
      },
      child: !isLoading?Scaffold(

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
          title: const Text(
            "HI,Member",
          ),
        ),
        body:isScanning?Center(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.orange,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          )
        ):SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isScanning=true;
                  });

                },
                child:Column(
                  children: [
                    if(!isScanned)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt,color: kPrimaryColor,size: 60,),
                        SizedBox(height: 10,),
                        Center(
                          child: Text("Scan QR of the Volunteer attendance report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    )
                    else
                      Column(
                        children: [
                          IdCardWidget(model,context,false),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AttendanceBuilder(id: result!.code!.toString(),isMember:true),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isScanned=false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                  decoration: BoxDecoration(
                                      color: kNewPrimaryColor,
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: const Text("Back"),
                                )
                            ),
                          )

                        ],
                      )

                  ],
                )
              ),
            ),
          ),
        ),
      ):const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}


Widget IdCardWidget(VolModel model,context,bool isVol){
  return Container
    (
    padding:const EdgeInsets.only(top: 20,bottom: 30,left: 10,right: 10),
    width: 500,
    child: Card
      (
      color: Colors.blueAccent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),

      ),

      child: Column
        (
        children: <Widget>[

          Container(
            color: Colors.blue.shade900,
            child: Row
              (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                const Padding(

                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Teen of God",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,

                    ),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10,right: 10),
                  child: InkWell
                    (
                    child: CircleAvatar(

                      // radius: MediaQuery.of(context).size.width*0.1,
                      backgroundColor: Colors.blueAccent,
                      child: Image.asset("assets/images/volunteer-icon.png"),

                    ),
                  ),
                ),

              ],
            ),

          ),


          Column(
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
                child: InkWell
                  (
                  child: CircleAvatar(

                    radius: MediaQuery.of(context).size.width*0.15,
                    backgroundColor: Colors.blueAccent,
                    child: Image.asset("assets/images/volunteer-icon.png"),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:75,left: 75),
                child: Text(model.info['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight:FontWeight.bold,
                  ),

                ),
              ),
              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),


                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['em'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),

                    ),


                  ),

                ],

              ),

              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Phone No.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),


                  ),
                  const SizedBox(width: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['phno'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                ],

              ),




              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),

                  ),
                  const SizedBox(width: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['address'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                ],

              ),

            ],
          ),
          if(isVol)
          const Padding(
                                    padding: EdgeInsets.only(top:15),
                                    child: Text("Scan for Attendance",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,

                                      ),


                                    ),
                                  ),
                                  if(isVol)
                                  Container
                                    (
                                    padding: const EdgeInsets.only(top: 10),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SizedBox(
                                          child: QrImage(
                                            data: FirebaseAuth.instance.currentUser!.uid,
                                            version: QrVersions.auto,
                                            size: 300.0,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
          const SizedBox(height: 20,),

        ],




      ),







    ),
  );
}
