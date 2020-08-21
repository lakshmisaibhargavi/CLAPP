import 'package:CLAP/clip.dart';

import 'package:CLAP/mainvideo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchProfile extends StatefulWidget {
  final user;

  const SearchProfile({Key key, this.user}) : super(key: key);
  @override
  _SearchProfileState createState() => _SearchProfileState();
}

class _SearchProfileState extends State<SearchProfile> {
  bool busy = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser person;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  bool following = false;
  bool requested = false;
  _validatefollow() {
    if (!following) {
      if (!widget.user['private']) {
        setState(() {
          following = true;
        });
        Firestore.instance
            .collection('users')
            .document(widget.user['url'])
            .updateData({
          'followers': FieldValue.arrayUnion([person.uid])
        });
        Firestore.instance.collection('users').document(person.uid).updateData({
          'following': FieldValue.arrayUnion([widget.user['url']])
        });
      } else {
        if (requested) {
          setState(() {
            requested = false;
          });
          Firestore.instance
              .collection('users')
              .document(widget.user['url'])
              .updateData({
            'requests': FieldValue.arrayRemove([person.uid])
          });
        } else {
          setState(() {
            requested = true;
          });
          Firestore.instance
              .collection('users')
              .document(widget.user['url'])
              .updateData({
            'requests': FieldValue.arrayUnion([person.uid])
          });
        }
      }
    } else {
      setState(() {
        following = false;
      });
      Firestore.instance
          .collection('users')
          .document(widget.user['url'])
          .updateData({
        'followers': FieldValue.arrayRemove([person.uid])
      });
      Firestore.instance.collection('users').document(person.uid).updateData({
        'following': FieldValue.arrayRemove([widget.user['url']])
      });
    }
  }

  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      person = _user;
    });
    for (var i in widget.user['followers']) {
      if (i == person.uid) {
        setState(() {
          following = true;
        });
      }
    }
    if (!following) {
      if (widget.user['private']) {
        for (var i in widget.user['requests']) {
          if (i == person.uid) {
            setState(() {
              requested = true;
            });
          }
        }
      }
      setState(() {
        following = false;
      });
    }
  }

  Widget build(BuildContext context) {
    List fo = widget.user['followers'];
    List posts = widget.user['video'];
    int fl = widget.user['following'].length;
    change() {
      if (following && !widget.user['private']) {
        fo.remove(person.uid);
        setState(() {});
      } else {
        fo.add(person.uid);
        setState(() {});
      }
      return fo;
    }

    return busy
        ? new Center(
            child: Image.asset(
              'assets/logo.gif',
              height: 200,
              width: 200,
            ),
          )
        : Scaffold(
            body: new Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(31, 66, 135, 20),
                          Color.fromRGBO(39, 142, 165, 20),
                          Color.fromRGBO(33, 230, 193, 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.07,
                    left: MediaQuery.of(context).size.width * 0.15,
                    child: Center(child: Image.asset('assets/name.png')),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.2,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(widget.user['profile_pic'])),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.3,
                      left: MediaQuery.of(context).size.width * 0.08,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.user['name'],
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.01,
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Positioned(
                      top: 170,
                      left: MediaQuery.of(context).size.width * 0.4,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    'Posts',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('Followers',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('Following',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black)),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    widget.user['video'].length.toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(fo.length.toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(fl.toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.4,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: FlatButton(
                      color: Colors.blue[700],
                      child: Text(!widget.user['private']
                          ? (following ? 'Unfollow' : 'Follow')
                          : (following
                              ? 'Unfollow'
                              : (requested ? 'Requested' : 'Request'))),
                      onPressed: () {
                        change();
                        _validatefollow();
                      },
                    ),
                  ),
                  Positioned(
                      top: 412,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 50,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            width: MediaQuery.of(context).size.width,
                            child: following
                                ? (widget.user['video'].length == 0
                                    ? Center(
                                        child: Text('no posts yet',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black)))
                                    : GridView.count(
                                        crossAxisCount: 2,
                                        children: List.generate(
                                            widget.user['video'].length,
                                            (index) {
                                          return Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                Firestore.instance
                                                    .collection('videos')
                                                    .document(posts[index]
                                                            ['url']
                                                        .toString()
                                                        .replaceAll('/', ','))
                                                    .get()
                                                    .then((value) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MainPlayer(
                                                                  link: posts[
                                                                      index])));
                                                });
                                              },
                                              child: Card(
                                                child: AppVideoPlayer(
                                                  link: posts[index],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ))
                                : Container(
                                    child: Center(
                                      child: Text('follow to view the content'),
                                    ),
                                  )),
                      )),
                ],
              ),
            ),
          );
  }
}
