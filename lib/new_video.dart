import 'dart:io';

import 'package:CLAP/cam.dart';
import 'package:CLAP/choose.dart';
import 'package:CLAP/dashboard.dart';
import 'package:CLAP/filepage.dart';
import 'package:CLAP/main.dart';
import 'package:CLAP/music.dart';
import 'package:CLAP/profile.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class New extends StatefulWidget {
  final List<CameraDescription> cameras;
  New({Key key, this.cameras}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    File image;
    return user != null
        ? Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CameraScreen(
                  cameras: cameras,
                ),
              ),
            ],
          )
        : Me();
  }
}

_opencam(BuildContext context) async {
  var pic = await ImagePicker.pickVideo(source: ImageSource.camera);
}
