import 'dart:async';

import 'package:CLAP/cam.dart';
import 'package:CLAP/choose.dart';
import 'package:CLAP/home.dart';
import 'package:CLAP/intro.dart';
import 'package:CLAP/new_video.dart';

import 'package:CLAP/wallet.dart';
import 'package:CLAP/search.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final user;

  const HomePage({Key key, this.cameras, this.user}) : super(key: key);
  @override
  _TabPageState createState() => _TabPageState(user);
}

class _TabPageState extends State<HomePage> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final user;
  int selectedIndex = 0;

  String c1 = '';
  String c3 = '';
  String c2 = '';
  String c4 = '';

  PageController controller = PageController();

  List<GButton> tabs = new List();

  _TabPageState(this.user);

  @override
  void initState() {
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
    Firestore.instance
        .collection('badges')
        .document('badges')
        .get()
        .then((value) {
      setState(() {
        c1 = value.data['c1'];
        c2 = value.data['c2'];
        c3 = value.data['c3'];
        c4 = value.data['c4'];
      });
    });

    var padding = EdgeInsets.symmetric(horizontal: 15, vertical: 6);
    double gap = 0;

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.purple,
      iconColor: Colors.black,
      textColor: Colors.purple,
      backgroundColor: Colors.purple.withOpacity(.2),
      iconSize: 20,
      padding: padding,
      icon: Icons.home,
      // textStyle: t.textStyle,
      text: 'HOME',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.pink,
      iconColor: Colors.black,
      textColor: Colors.pink,
      backgroundColor: Colors.pink.withOpacity(.2),
      iconSize: 20,
      padding: padding,
      icon: Icons.search,
      // textStyle: t.textStyle,
      text: 'SEARCH',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.amber[600],
      iconColor: Colors.black,
      textColor: Colors.amber[600],
      backgroundColor: Colors.amber[600].withOpacity(.2),
      iconSize: 20,
      padding: padding,
      icon: Icons.add_a_photo,
      // textStyle: t.textStyle,
      text: 'VIDEO',
    ));
    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.teal,
      iconColor: Colors.black,
      textColor: Colors.teal,
      backgroundColor: Colors.teal.withOpacity(.2),
      iconSize: 20,
      padding: padding,
      icon: Icons.person,
      // textStyle: t.textStyle,
      text: 'PROFILE',
    ));
    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.yellow,
      iconColor: Colors.black,
      textColor: Colors.black,
      backgroundColor: Colors.yellow.withOpacity(.2),
      iconSize: 20,
      padding: padding,
      icon: Icons.account_balance_wallet,
      // textStyle: t.textStyle,
      text: 'WALLET',
    ));
  }

  Future<bool> out() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit clapp'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  bool da = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [
      Home(),
      Search(),
      New(cameras: cameras),
      Me(),
      Noti(
        user: widget.user,
      )
    ];
    List streek;
    int time;
    int date;
    Timer.periodic(Duration(minutes: 5), (Timer t) async {
      date = DateTime.now().day;
      Firestore.instance
          .collection('users')
          .document(user)
          .get()
          .then((value) async {
        streek = await value.data['streek'];
        time = value.data['stime'];
      });
      print(date);

      if ((streek.contains((date - 1).toString()) ||
              streek.contains(date.toString()) ||
              streek.length == 0) &&
          streek.length < 8) {
        print('done');
        if (!streek.contains(date) && streek.contains((date - 1).toString())) {
          Firestore.instance.collection('users').document(user).updateData({
            'streek': FieldValue.arrayUnion(
              ['$date'],
            ),
            'stime': time + 5
          });
        } else if (streek.length == 0) {
          Firestore.instance.collection('users').document(user).updateData({
            'streek': FieldValue.arrayUnion(
              ['$date'],
            ),
            'stime': time + 5
          });
        } else {
          Firestore.instance
              .collection('users')
              .document(user)
              .updateData({'stime': time + 5});
        }
        if (streek.length == 7) {
          print('achieved');
          var fin = time / 7;
          print(fin);
          if (fin > 30) {
            Firestore.instance.collection('users').document(user).updateData({
              'streek': [],
              'stime': 0,
              'badges': FieldValue.arrayUnion([c1])
            });
          } else if (fin > 25) {
            print(25);
            Firestore.instance.collection('users').document(user).updateData({
              'streek': [],
              'stime': 0,
              'badges': FieldValue.arrayUnion([c2])
            });
          } else if (fin > 20) {
            print(20);
            Firestore.instance.collection('users').document(user).updateData({
              'streek': [],
              'stime': 0,
              'badges': FieldValue.arrayUnion([c3])
            });
          } else if (fin > 15) {
            Firestore.instance.collection('users').document(user).updateData({
              'streek': [],
              'stime': 0,
              'badges': FieldValue.arrayUnion([c4])
            });
          } else {
            Firestore.instance
                .collection('users')
                .document(user)
                .updateData({'streek': [], 'stime': 0});
          }
        }
      } else {
        Firestore.instance
            .collection('users')
            .document(user)
            .updateData({'streek': [], 'stime': 0});
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: out,
        child: new Scaffold(
          extendBody: true,

          body: PageView.builder(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
              });
            },
            controller: controller,
            itemBuilder: (context, position) {
              return screen[position];
            },
            itemCount: tabs.length, // Can be null
          ),
          // backgroundColor: Colors.green,
          // body: Container(color: Colors.red,),
          bottomNavigationBar: FittedBox(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -1,
                        blurRadius: 50,
                        color: Colors.black.withOpacity(.20),
                        offset: Offset(0, 15))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: FittedBox(
                  child: GNav(
                      tabs: tabs,
                      selectedIndex: selectedIndex,
                      onTabChange: (index) {
                        print(index);
                        setState(() {
                          selectedIndex = index;
                        });
                        controller.jumpToPage(index);
                      }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
