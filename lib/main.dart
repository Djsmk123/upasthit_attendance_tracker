import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/providers/attendance_provider.dart';
import 'package:upasthit/providers/form_error.dart';
import 'package:upasthit/screens/forns/user_form.dart';
import 'package:upasthit/screens/welcome_screen.dart';

import 'firebase_options.dart';
import 'models/collection.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>FormErrorModel()),
        ChangeNotifierProvider(create: (_)=>AttendanceProvider())
      ],
      child: MaterialApp(
          theme: ThemeData(useMaterial3: true,
              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          home: const WelcomeScreen()),
    );
  }
}


