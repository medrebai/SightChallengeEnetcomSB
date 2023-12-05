import 'package:flutter/material.dart';
import 'package:sightfinal/screens/auth_ui/login/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sightfinal/screens/splitscreen/splitscreen.dart';
import 'package:sightfinal/screens/water_management_screen/water_Managemen_screen.dart';


void  main() async {
    WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}