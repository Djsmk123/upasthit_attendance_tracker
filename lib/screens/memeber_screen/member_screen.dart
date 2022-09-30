// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:upasthit/components/rounded_button.dart';
import 'package:upasthit/constants.dart';
import 'package:upasthit/providers/attendance_provider.dart';
import 'package:upasthit/services/firebase_services.dart';

import '../../Models/users_models.dart';
import '../../components/id_card.dart';
import '../../services/logins_signup_services.dart';
import '../attendace_components/attandance_builder.dart';
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
  bool isApproved=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();

  }
  Future<void> initAsync() async {
    try{
      setState(() {
        isLoading=true;
      });
      isApproved= await FirebaseService.isApproved(uid: FirebaseAuth.instance.currentUser!.uid);

    }catch(e){
      log(e.toString());
    }finally{
      setState(() {
        isLoading=false;
      });
    }
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
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final VolModel model=Provider.of<AttendanceProvider>(context).getVolModel;
    print(isScanned);
    if(isScanning) {
      readQr();
    }
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
                onPressed: () async {
                  setState(() {
                    isLoading=true;
                  });
                  try{
                    await Authentication().logOut();
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (builder)=>const WelcomeScreen()));
                  }catch(e){
                    log(e.toString());
                    Fluttertoast.showToast(msg: "Something went wrong");
                    setState(() {
                      isLoading=false;
                    });
                  }
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
              child: Column(
                children: [
                  Visibility(
                    visible: !isScanned && isApproved,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          isScanning=true;
                        });
                      },
                      child: Column(
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
                      ),
                    ),
                  ),
                    if(isScanned && isApproved)
                    Column(
                      children: [
                        IdCardWidget(model,context,false),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AttendanceBuilder(id: result!.code!.toString(),isMember:true),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedButton(
                            text: "Back",
                            color: Colors.grey,
                            press: (){
                              setState(() {
                                isScanned=false;
                                result=null;
                              });
                            },
                          )
                        )

                      ],
                    ),
                  if(!isApproved)
                    const Center(
                      child:  Text("Your Account has not been Approved yet.\nPlease wait until approve",textAlign: TextAlign.center,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    )

                ],
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



