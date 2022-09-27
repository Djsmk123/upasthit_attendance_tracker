// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upasthit/constants.dart';
import 'package:upasthit/screens/choice_page.dart';
import 'package:upasthit/screens/forns/member_form.dart';
import 'package:upasthit/screens/forns/user_form.dart';
import 'package:upasthit/screens/login_screen.dart';
import 'package:upasthit/screens/memeber_screen/member_screen.dart';
import 'package:upasthit/screens/signup_screen.dart';
import 'package:upasthit/screens/user_vol_screen/VolunteerScreen.dart';
import '../../services/logins_signup_services.dart';
import '../components/CustomProgressIndicator.dart';
import '../components/rounded_button.dart';
import '../services/custom_exception_handler.dart';
import 'admin_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool? isLoading = true;
  final auth = FirebaseAuth.instance;
  final service = Authentication();
  bool isInitComplete = false;
  @override
  void initState() {
    super.initState();
    initLoad().then((value) {
      setState(() {
        isInitComplete = true;
        init();
      });
    });
  }

  Future<bool> initLoad() async {
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    return true;
  }

  navigator() async {
    try{
      var doc=await service.collections.userType.doc(auth.currentUser!.uid).get();
      role=doc.get('role');
      await Future.delayed(const Duration(seconds: 1));
      switch(role)
      {
       case 'v': {

         var vol=await service.collections.userData.doc(auth.currentUser!.uid).get();
         Navigator.pop(context);
         if(vol.exists) {
           Navigator.push(context, MaterialPageRoute(builder: (builder)=>const VolScreen()));
         }
         else{
           Navigator.push(context, MaterialPageRoute(builder: (builder)=>const UserForms()));
         }
         break;
       }
         case 'm':{
           var vol=await service.collections.member.doc(auth.currentUser!.uid).get();
           Navigator.pop(context);
           if(vol.exists) {
             Navigator.push(context, MaterialPageRoute(builder: (builder)=>const MemberScreen()));
           }
           else{
             Navigator.push(context, MaterialPageRoute(builder: (builder)=>const MemberForm()));
           }
       break;
        }
        case 'a':{
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>const AdminScreen()));
          break;
        }
      }

    }
    catch(error){
      FirebaseAuth.instance.signOut();
      if (error.runtimeType == CustomExceptionHandler) {

        FirebaseAuth.instance.signOut();
      } else {
        Fluttertoast.showToast(msg: "Error while loading data");
      }

    }

  }

  Future<void> init() async {
      if (isInitComplete) {
        foregroundNotification();
      }
    User? user = await getFirebaseUser();
    if (user != null && isInitComplete) {
      navigator();
    } else {
      if (isInitComplete) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/appLogo.png",
              width: !isWeb(size) ? size.width * 0.8 : 500, height: 150),
          SizedBox(height: size.height * 0.05),
          if (isLoading != null)
            if (isLoading!)
              const Center(
                child: CustomProgressIndicator(),
              ),
          SizedBox(height: size.height * 0.05),
          if (isLoading != null)
            if (!isLoading!)
              RoundedButton(
                text: "LOGIN",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>const LoginScreen()));
                },
              ),
          const SizedBox(height: 20),
          if (isLoading != null)
            if (!isLoading! && !kIsWeb)
              RoundedButton(
                text: "SIGN UP",
                color: kPrimaryLightColor,
                textColor: Colors.black,
                press: () {
                  if(kIsWeb)
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const SignUpScreen(index: 2)));
                    }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ChoicePage()));
                  }

                },
              ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width:!isWeb(size)?size.width * 0.3:0,
              //  width: isWeb(size)?size.width*0.3:size.width * 0.3,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/main_bottom.png",
                width: isWeb(size) ? 0 : size.width * 0.3
              //width: isWeb(size)?double.infinity:size.width * 0.3,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

Future getFirebaseUser() async {
  var auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    return auth.authStateChanges().first;
  }
  return auth.currentUser;
}
Future<void> onBackgroundMessage(RemoteMessage message) async {
  debugPrint("BackgroundNotificationHandler");
}
FlutterLocalNotificationsPlugin fltNotification =FlutterLocalNotificationsPlugin();
final notification = FirebaseMessaging.instance;
void foregroundNotification() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    RemoteNotification? notification = event.notification;
    AndroidNotification? android = event.notification?.android;
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    fltNotification.initialize(initializationSettings);
    if (notification != null && android != null) {
      fltNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });
}