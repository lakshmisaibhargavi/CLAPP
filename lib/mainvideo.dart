import 'package:CLAP/searchprofile.dart';
import 'package:CLAP/spinner_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MainPlayer extends StatefulWidget {
  final link;

  const MainPlayer({Key key, this.link}) : super(key: key);
  _MainPlayerState createState() => _MainPlayerState(link);
}

class _MainPlayerState extends State<MainPlayer> {
  final link;
  VideoPlayerController _controller;

  _MainPlayerState(this.link);
  var user;
  List followers;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser person;

  bool isliked = false;
  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      person = _user;
    });
    print(user);
    for (var i in link['likes']) {
      if (i == person.uid) {
        setState(() {
          isliked = true;
        });
      } else {
        setState(() {
          isliked = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();

    _controller = VideoPlayerController.network(link['url'])
      ..initialize().then((_) {
        _controller.play();

        setState(() {});
      });
    Firestore.instance
        .collection('users')
        .document(link['user'])
        .get()
        .then((value) {
      setState(() {
        user = value;
      });
    });
    Firestore.instance
        .collection('videos')
        .document(link['url'].replaceAll('/', ','))
        .updateData({'runtime': link['runtime'] + 1});
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (isLiked) {
      Firestore.instance
          .collection('videos')
          .document(link['url'].replaceAll('/', ','))
          .updateData({
        'likes': FieldValue.arrayRemove([person.uid])
      });
      if (link['likes'].length >= 200 && user['followers'].length >= 500) {
        Firestore.instance
            .collection('users')
            .document(link['user'])
            .updateData({
          'likes': FieldValue.arrayRemove([person.uid])
        });
      }
    } else {
      Firestore.instance
          .collection('videos')
          .document(link['url'].replaceAll('/', ','))
          .updateData({
        'likes': FieldValue.arrayUnion([person.uid])
      });
      if (link['likes'].length >= 200 && user['followers'].length >= 500) {
        Firestore.instance
            .collection('users')
            .document(link['user'])
            .updateData({
          'likes': FieldValue.arrayUnion([person.uid])
        });
      }
    }
    return !isLiked;
  }

  Future downloadFile(String url) async {
    Dio dio = Dio();

    try {
      var dir =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.mp4');
      print(dir);
      await dio.download(url, dir, onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.7,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Container(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/logo.png',
                                  height: 30,
                                  width: 30,
                                ),
                                FittedBox(
                                  child: Text(
                                    user['name'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 60,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: user['badges'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: CircleAvatar(
                                            child: Image.network(
                                                user['badges'][index]),
                                            radius: 10,
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                            Text(
                              link['links'],
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal),
                            ),
                            Text(link['catogory'].toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueAccent,
                                    fontStyle: FontStyle.italic))
                          ],
                        ),
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.40,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print(user);
                                    if (user['url'] != person.uid) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchProfile(
                                                    user: user,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                user['profile_pic']))),
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: LikeButton(
                              isLiked: isliked,
                              size: 35,
                              onTap: (isLiked) => onLikeButtonTapped(isLiked),
                              circleColor: CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color:
                                      isLiked ? Colors.red[900] : Colors.grey,
                                  size: 40,
                                );
                              },
                              likeCount: link['likes'].length,
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color =
                                    isLiked ? Colors.white : Colors.white;
                                Widget result;
                                if (count == 0) {
                                  result = Text(
                                    "like",
                                    style: TextStyle(color: color),
                                  );
                                } else
                                  result = Text(
                                    text,
                                    style: TextStyle(color: color),
                                  );
                                return result;
                              },
                              // ignore: missing_return
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print('down');
                                  },
                                  child: Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SpinnerAnimation(
                              body: audioSpinner(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
            child: Image.asset(
              'assets/logo.gif',
              height: 200,
              width: 200,
            ),
          ));
  }

  Widget audioSpinner() {
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            gradient: audioDiscGradient,
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage("assets/logo.png"))));
  }

  LinearGradient get audioDiscGradient => LinearGradient(colors: [
        Color.fromRGBO(31, 66, 135, 0.8),
        Color.fromRGBO(39, 142, 165, 20),
        Color.fromRGBO(33, 230, 193, 10),
      ], stops: [
        0.0,
        0.4,
        0.6
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
