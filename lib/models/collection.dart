import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Collections {
  final member = FirebaseFirestore.instance.collection('member');
  final userData = FirebaseFirestore.instance.collection('users_data');
  final adminData=FirebaseFirestore.instance.collection('admin');
   User? user=FirebaseAuth.instance.currentUser;
  final userType = FirebaseFirestore.instance.collection('users');
}
