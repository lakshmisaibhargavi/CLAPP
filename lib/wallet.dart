import 'package:CLAP/redeem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Noti extends StatefulWidget {
  final user;

  const Noti({Key key, this.user}) : super(key: key);
  @override
  _NotiState createState() => _NotiState(user);
}

class _NotiState extends State<Noti> {
  int ref = 0;
  int li = 0;
  final user;
  String code = '';
  var data = {};
  bool busy = false;
  _NotiState(this.user);
  @override
  void initState() {
    super.initState();
    getdata();
  }

  int wallet = 0;

  getdata() {
    setState(() {
      busy = true;
    });
    Firestore.instance
        .collection('users')
        .document(widget.user)
        .get()
        .then((value) {
      setState(() {
        data = value.data;
        wallet = value.data['wallet'];
        ref = data['urlusers'].length;
        li = data['likes'].length;
        code = data['url'];
      });
      print(data);
    });
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool dark = false;

    return !busy
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: dark
                    ? LinearGradient(colors: [
                        Color.fromRGBO(5, 23, 48, 10),
                        Color.fromRGBO(5, 23, 48, 10)
                      ])
                    : LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(33, 230, 193, 20),
                          Color.fromRGBO(39, 142, 165, 20),
                          Color.fromRGBO(31, 66, 135, 20),
                        ],
                      ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            'Wallet',
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 150,
                            width: 150,
                            child: Image.network(
                                'https://cdn2.iconfinder.com/data/icons/fintech-butterscotch-vol-2/512/Wallet-512.png'),
                          ),
                          Text(
                            '=    ' + wallet.toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                            width: 50,
                            child: Image.network(
                                'http://pngimg.com/uploads/coin/coin_PNG36887.png'),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.favorite),
                            ),
                            Text(
                              'Like Earnings =',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              '  ' + (li).toString(),
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.95,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.share),
                            ),
                            Text(
                              'Referal Earnings =',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              '  ' + (ref * 50).toString(),
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.95,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.star_half),
                            ),
                            Text(
                              'Number of Referals =',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              '  ' + ref.toString(),
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Card(
                          elevation: 5,
                          child: GestureDetector(
                            onTap: () {
                              out(code);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 300,
                              child: Text(
                                'INVITE FRIENDS',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Card(
                          elevation: 5,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Redeem(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 300,
                              child: Text(
                                'REDEEM',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Image.asset(
              'assets/logo.gif',
              height: 200,
              width: 200,
            ),
          );
  }

  Future<bool> out(ref) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Invite Friends',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            content: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/logo.gif',
                    height: 100,
                    width: 100,
                  ),
                  Text(
                      'Refer your friend and earn 50 Clapp coins and your friend earns 50 Clapp coins'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                color: Colors.blue,
                onPressed: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(
                    'This is referal code to join Clapp family\nBy using this code you will be getting 100 clap coins for free\ncode:$code',
                  );
                },
                child: Text(
                  "Send",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
