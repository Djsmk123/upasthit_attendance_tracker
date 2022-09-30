// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    // ignore: unused_shown_name
    show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/components/CustomProgressIndicator.dart';
import 'package:upasthit/models/collection.dart';
import 'package:upasthit/screens/admin/admin_screen.dart';
import 'package:upasthit/screens/forms/member_form.dart';
import 'package:upasthit/screens/forms/user_form.dart';

import '../../constants.dart';
import '../../services/logins_signup_services.dart';
import '../components/FadeAnimation.dart';
import '../components/rounded_input_field.dart';
import '../providers/form_error.dart';
import 'memeber_screen/member_screen.dart';
import 'user_vol_screen/VolunteerScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? email;

  String? password;

  final authServices = Authentication();
  final collections = Collections();

  var isLoading = false;

  var isResetPassword = false;
  final notifToken = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Provider.of<FormErrorModel>(context, listen: false).resetErrors();
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (isResetPassword) {
          setState(() {
            isResetPassword = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100 - size.height * 0.05,
                  ),
                  FadeAnimation(
                    1,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/attendance-management.png",
                        width: !isWeb(size) ? size.width * 0.8 : 500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FadeAnimation(
                              1.8,
                              RoundedInputField(
                                hintText: "Your Email",
                                errorKey: 'email',
                                keyboardType1: TextInputType.emailAddress,
                                validator: (value) {
                                  var message = "";
                                  if (value!.isEmpty) {
                                    message = "Email can't be empty.";
                                    Provider.of<FormErrorModel>(context,
                                            listen: false)
                                        .setFormError("email", message);
                                    return message;
                                  } else if (!(RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value))) {
                                    message = "Enter a valid email";
                                    Provider.of<FormErrorModel>(context,
                                            listen: false)
                                        .setFormError("email", message);
                                    return message;
                                  }
                                  Provider.of<FormErrorModel>(context,
                                          listen: false)
                                      .setFormError("email", message);
                                  return null;
                                },
                                onChanged: (value) {
                                  email = value;
                                },
                                isPassword: false,
                              ),
                            ),
                            if (!isResetPassword)
                              FadeAnimation(
                                1.8,
                                RoundedInputField(
                                  keyboardType1: TextInputType.visiblePassword,
                                  icon: Icons.lock,
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                  hintText: 'Enter password',
                                  isPassword: true,
                                  errorKey: 'pass',
                                ),
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeAnimation(
                                2,
                                Bounce(
                                  duration: const Duration(milliseconds: 200),
                                  onPressed: !isLoading
                                      ? () async {
                                          onSubmit();
                                        }
                                      : () {},
                                  child: Container(
                                    height: 50,
                                    width: !isWeb(size) ? size.width * 0.8 : 500,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ])),
                                    child: !isLoading
                                        ? Text(
                                            !isResetPassword
                                                ? "Login"
                                                : "Reset Password",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const CustomProgressIndicator(
                                            color: Colors.white,
                                          ),
                                  ),
                                )),
                            if (!isResetPassword)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 50,
                                    horizontal: !isWeb(size) ? 10 : 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FadeAnimation(
                                        1.5,
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isResetPassword = true;
                                            });
                                          },
                                          child: const Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 1)),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (!isResetPassword) {

        await authServices.login(email: email!, password: password!).then((value) async {
          String? token;
          token = await notifToken.getToken();
          await collections.userType.doc(Collections().user!.uid).update({'token': token});
          await collections.userType.doc(Collections().user!.uid).get().then((doc) async {
            role = doc.get('role');
            if (kIsWeb && role != 'a') {
              Fluttertoast.showToast(
                  msg:
                  "Please contact administrator,you do not have to permission to access.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5);
              FirebaseAuth.instance.signOut();
            }
            else
            {
              print('heer');
              switch(role)
              {
                case 'v': {

                  var vol=await authServices.collections.userData.doc(FirebaseAuth.instance.currentUser!.uid).get();
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
                  var vol=await authServices.collections.member.doc(FirebaseAuth.instance.currentUser!.uid).get();
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
          });
        }).catchError((error) {
          log(error.toString());
          if(FirebaseAuth.instance.currentUser!=null) {
            FirebaseAuth.instance.signOut();
          }
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: error.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5);
        });
      } else {
        await authServices.resetPassword(email: email!).catchError((error) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: error.message.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5);
        }).then((value) {
          setState(() {
            isResetPassword = false;
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Password reset email has been sent to your email address.",
          );
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
