// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:upasthit/screens/forns/member_form.dart';
import 'package:upasthit/screens/forns/user_form.dart';
import 'package:upasthit/screens/memeber_screen/member_screen.dart';

import '../../services/logins_signup_services.dart';
import '../components/FadeAnimation.dart';
import '../components/already_have_an_account_acheck.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../constants.dart';

import '../models/collection.dart';
import '../providers/form_error.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final int index;
  const SignUpScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        index: widget.index,
      ),
    );
  }
}

class Body extends StatefulWidget {
  final int index;
  const Body({Key? key, required this.index}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  FormErrorModel errorModel = FormErrorModel();
  String? password;
  final notifToken = FirebaseMessaging.instance;
  final authServices = Authentication();
  var isLoading = false;
  @override
  initState() {
    super.initState();
    if (mounted) {
      Provider.of<FormErrorModel>(context, listen: false).resetErrors();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Background(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
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
                SizedBox(height: size.height * 0.03),
                FadeAnimation(
                  1.8,
                  RoundedInputField(
                    hintText: "Your Email",
                    errorKey: 'email',
                    isPassword: false,
                    keyboardType1: TextInputType.emailAddress,
                    validator: (value) {
                      var message = "";
                      if (value!.isEmpty) {
                        message = "Email can't be empty.";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("email", message);
                        return message;
                      } else if (!(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))) {
                        message = "Enter a valid email";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("email", message);
                        return message;
                      }
                      Provider.of<FormErrorModel>(context, listen: false)
                          .setFormError("email", message);
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                FadeAnimation(
                  1.8,
                  RoundedInputField(
                    icon: Icons.lock,
                    keyboardType1: TextInputType.visiblePassword,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      var message = "";
                      if (value!.isEmpty) {
                        message = "Password can't be empty.";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("pass", message);
                        return message;
                      } else if (value.length < 8) {
                        message = "Weak Password";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("pass", message);
                        return message;
                      }
                      Provider.of<FormErrorModel>(context, listen: false)
                          .setFormError("pass", message);
                      return null;
                    },
                    errorKey: 'pass',
                    isPassword: true,
                    hintText: 'Your Password',
                  ),
                ),
                FadeAnimation(
                  2,
                  RoundedButton(
                    text: "SIGN UP",
                    isLoading: isLoading,
                    press: !isLoading ? onSubmit : () {

                    },
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                FadeAnimation(
                  2,
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const LoginScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Collections collections = Collections();
  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate() &&
        email!.isNotEmpty &&
        password!.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await authServices.signUp(email: email!, password: password!).then((value) async {
        String? token;
        token = await notifToken.getToken();
        await FirebaseFirestore.instance.collection('users').doc(Collections().user!.uid).set({
          'role': widget.index == 0 ?'v':'m',
          'token': token,
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
          authServices.collections.user!.delete();
        });
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>(widget.index==1?const MemberForm():const UserForms())));

      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: error.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM_LEFT,
            timeInSecForIosWeb: 5);
      });
      setState(() {
        isLoading = false;
      });
    }
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
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/main_bottom.png",
                width: isWeb(size) ? 0 : size.width * 0.3
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}


