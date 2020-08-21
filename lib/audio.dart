import 'package:CLAP/clipcam.dart';
import 'package:CLAP/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Music extends StatefulWidget {
  final type;
  @override
  const Music({Key key, this.type}) : super(key: key);
  _MusicState createState() => _MusicState(type);
}

class _MusicState extends State<Music> {
  _MusicState(this.type);
  AudioPlayer audioPlayer = AudioPlayer();
  final type;
  String n;

  bool busy = false;
  List name;
  List urls;
  getdata() async {
    if (type == 'Telugu_songs') {
      setState(() {
        n = 'Names';
      });
    } else {
      n = 'Name';
    }
    setState(() {
      busy = true;
    });
    print(busy);
    await Firestore.instance
        .collection('songs')
        .document('$type')
        .get()
        .then((value) {
      print(value.data);
      setState(() {
        name = value.data[n];
        urls = value.data['url'];
      });
    });
    print(name);
    setState(() {
      busy = false;
    });
  }

  void initState() {
    super.initState();
    getdata();
  }

  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool playing = false;
    return busy
        ? Scaffold(
            body: Center(
              child: Image.asset('assets/logo.gif', height: 200, width: 200),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(33, 230, 193, 10),
              title: Text(
                'Choose songs',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(33, 230, 193, 10),
                      Color.fromRGBO(39, 142, 165, 20),
                      Color.fromRGBO(31, 66, 135, 0.8),
                    ],
                  ),
                ),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          audioPlayer.stop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClipCam(
                                  cameras: cameras,
                                  song: urls[index],
                                  name: name[index],
                                ),
                              ));
                        },
                        onDoubleTap: () async {
                          await audioPlayer.stop();
                        },
                        onTap: () async {
                          audioPlayer.play(urls[index]);
                          setState(() {
                            playing = true;
                          });

                          print(urls[index]);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          color: Colors.grey[200],
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(name[index]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: name.length)),
          );
  }
}
