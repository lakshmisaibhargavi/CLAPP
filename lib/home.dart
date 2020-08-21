import 'dart:async';
import 'dart:math';
import 'package:CLAP/filepage.dart';
import 'package:CLAP/mainvideo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String device = 'ca-app-pub-5442550148157500~2960390086';
const String unitid = 'ca-app-pub-5442550148157500/8274202616';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: device != null ? <String>[device] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );
  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: unitid,

        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  int selectedIndex = 0;

  PageController controller = PageController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getuser();
    FirebaseAdMob.instance.initialize(appId: device);
    //Change appId With Admob Id
    _interstitialAd = createInterstitialAd()..load();
    super.initState();
  }

  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  List following = [];
  Future<void> getuser() async {
    setState(() {
      busy = true;
    });
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      user = _user;
    });
    if (user != null) {
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) {
        setState(() {
          following = value.data['following'];
        });
        print(following);
      });
    }
    if (following.length < 100) {
      getdata();
    } else {
      data();
    }
  }

  List posts = [];
  var cata;
  int len;
  Future<void> data() async {
    print(following);
    var re = await Firestore.instance
        .collection("videos")
        .where('user', whereIn: following)
        .getDocuments();

    re.documents.forEach((element) {
      print(element);
      posts.add(element);
    });
    setState(() {
      busy = false;
      len = posts.length;
    });
  }

  getdata() async {
    setState(() {
      busy = true;
    });
    var re = await Firestore.instance
        .collection("videos")
        .orderBy('runtime', descending: true)
        .getDocuments();

    re.documents.forEach((element) {
      print(element.data);
      if (element['private'] == false) {
        posts.add(element);
      }
    });
    setState(() {
      len = posts.length;
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(minutes: 2), (Timer t) {
      createInterstitialAd()
        ..load()
        ..show();
    });
    return busy
        ? MaterialApp(
            home: Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Image.asset(
                  'assets/logo.gif',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          )
        : Scaffold(
            body: GestureDetector(
              onDoubleTap: () {
                print('liked');
              },
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                onPageChanged: (page) {
                  setState(() {
                    selectedIndex = page;
                  });
                },
                controller: controller,
                itemBuilder: (context, position) {
                  return MainPlayer(
                    link: posts[Random().nextInt(posts.length)],
                  );
                },
                itemCount: len, // Can be null
              ),
            ),
          );
  }
}
