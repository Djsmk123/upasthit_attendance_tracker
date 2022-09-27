
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const kPrimaryColor = Color(0xFF5C6BC0);
const kNewPrimaryColor = Color(0XFF54C4CC);
const kPrimaryLightColor = Color(0xFFEDE7F6);
var role = "";
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    playSound: true);


isWeb(Size size) {
  if (size.width > 600) {
    return true;
  } else {
    return false;
  }
}