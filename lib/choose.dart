import 'package:CLAP/phone.dart';
import 'package:CLAP/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;

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
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(body: user != null ? Profile(user: user) : PhoneAuth());
  }
}
