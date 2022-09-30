

// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/collection.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;
  final Collections collections = Collections();

  Future signUp({required String email, required String password}) async {
    var errorMessage = "";
    var user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user)  {
      if (user.user != null) {
        return 0;
      }
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = ("Your password is too weak");
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = ("Your email is invalid");
          break;
        case "email-already-in-use":
          errorMessage = ("Email is already in use on different account");
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = ("Your email is invalid");
          break;
        default:
          errorMessage = ("Something went wrong,try again.");
          break;
      }
    });
    if (errorMessage.isNotEmpty || user == null) {
      throw Exception(errorMessage);
    }
  }

  Future login({required String email, required String password}) async {
    var errorMessage="";
    int? user = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
    }).catchError((error) {
      print('error'+error.toString());
      switch (error.code.toString().toLowerCase()) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong";
      }
    });
    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
    return null;
  }

  Future addData({required int index, required Map data}) async {
    switch (index) {
      case 0:
        {
          collections.userData.doc(_auth.currentUser!.uid).set({
            'info': data['info'],
            'attendance':[

            ],
            'donations':[

            ]
          }).catchError((error) {
            throw Exception(error);
          });
          break;
        }
      case 1:
        {
          collections.member.doc(_auth.currentUser!.uid).set({
            'info': data['info'],
            'isApproved':null
          }).catchError((error) {
            throw Exception(error);
          });
          break;
        }
    }
  }

  Future resetPassword({required String email}) async {
    var errorMessage = "";
    await _auth.sendPasswordResetEmail(email: email).then((user) {
      return 0;
    }).catchError((error) {
      switch (error.code.toString().toLowerCase()) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong";
      }
    });
    throw Exception(errorMessage);
  }

  Future logOut() async {
    await FirebaseMessaging.instance.deleteToken();
    await collections.userType
        .doc(_auth.currentUser!.uid)
        .update({'token': null}).catchError((error) {
      print(error);
      throw Exception("Something went wrong");
    });
    await _auth.signOut().catchError((error) {
      throw Exception("Something went wrong");
    });
  }
}
