import 'dart:io';

import 'package:CLAP/audio.dart';
import 'package:CLAP/audioedit.dart';
import 'package:camera/new/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Audio extends StatefulWidget {
  final camera;

  const Audio({Key key, this.camera}) : super(key: key);
  @override
  _AudioState createState() => _AudioState(camera);
}

class _AudioState extends State<Audio> {
  final camera;
  bool busy = true;
  List type = [];
  @override
  void initState() {
    super.initState();

    Firestore.instance.collection('spic').document('pic').get().then((value) {
      setState(() {
        type = value.data['pic'];
        busy = false;
      });
    });
  }

  _AudioState(this.camera);
  @override
  Widget build(BuildContext context) {
    List types = [
      'Bengali_songs',
      'English_songs',
      'Hindi_dialogue',
      'Hindi_songs',
      'Kannada_dialogues',
      'Kannada_songs',
      'Malayalam_dialogues',
      'Malayalam_songs',
      'Marathi_dialogues',
      'Marathi_songs',
      'Tamil_dialogues',
      'Tamil_songs',
      'Telugu_dialogues',
      'Telugu_songs'
    ];
    List name = [
      'Bengali songs',
      'English songs',
      'Hindi dialogue',
      'Hindi songs',
      'Kannada dialogues',
      'Kannada songs',
      'Malayalam dialogues',
      'Malayalam songs',
      'Marathi dialogues',
      'Marathi songs',
      'Tamil dialogues',
      'Tamil songs',
      'Telugu dialogues',
      'Telugu songs'
    ];

    return !busy
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(33, 230, 193, 10),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Aedit(
                                    camera: camera,
                                  )));
                    },
                    child: Text(
                      'From Device',
                      style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                    ))
              ],
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  }),
              title: Text('AUDIO'),
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
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(types.length, (index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Music(
                                      type: types[index],
                                    )));
                      },
                      child: Stack(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 300,
                              width: 200,
                              child: Image.network(
                                type[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            child: Text(
                              name[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ))
        : Scaffold(
            body: Center(
              child: Image.network(
                'assets/logo.gif',
                height: 200,
                width: 200,
              ),
            ),
          );
  }
}
