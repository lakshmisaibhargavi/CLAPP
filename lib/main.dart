import 'package:CLAP/dashboard.dart';
import 'package:CLAP/intro.dart';
import 'package:CLAP/start.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:async';

List<CameraDescription> cameras;

Future<void> main() async {
  runApp(
    new MyApp(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;

  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      user = _user;
    });
    print(user);
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            primaryColor: Colors.white,
            primaryColorDark: Colors.white30,
            accentColor: Colors.blue),
        home: user != null
            ? HomePage(cameras: cameras, user: user.uid)
            : Start(
                camera: cameras,
              ));
  }
}
