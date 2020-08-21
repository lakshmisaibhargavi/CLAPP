import 'dart:io';

import 'package:CLAP/clip.dart';
import 'package:CLAP/mainvideo.dart';
import 'package:CLAP/phone.dart';
import 'package:CLAP/request.dart';
import 'package:CLAP/rewards.dart';
import 'package:CLAP/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class Profile extends StatefulWidget {
  final user;

  const Profile({Key key, this.user}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool busy = true;

  @override
  void initState() {
    super.initState();
    data();
  }

  var firebaseUser = FirebaseAuth.instance.currentUser();

  bool dark = false;
  var name;
  List followers = [];
  List following = [];
  List posts = [];
  int wallet;
  var code;
  var pic;
  bool private = false;
  List requests = [];
  List badges = [];
  Future<dynamic> data() {
    setState(() {
      busy == true;
    });
    Firestore.instance
        .collection("users")
        .document(widget.user.uid)
        .get()
        .then((value) {
      setState(() {
        private = value.data['private'];
        badges = value.data['badges'];
        requests = value.data['requests'];
        name = value.data['name'];
        followers = value.data['followers'];
        following = value.data['following'];
        posts = value.data['video'];
        code = value.data['url'];
        pic = value.data['profile_pic'];

        wallet = value.data['wallet'];
        busy = false;
      });

      if (!posts.contains(
              'https://firebasestorage.googleapis.com/v0/b/clap-2425e.appspot.com/o/badges%2FGB.jpeg?alt=media&token=e4b1b1cd-826e-4f56-a9cc-484180784b21') &&
          value.data['urlusers'].length > 15) {
        Firestore.instance
            .collection('users')
            .document(value.data['url'])
            .updateData({
          'badges': FieldValue.arrayUnion([
            'https://firebasestorage.googleapis.com/v0/b/clap-2425e.appspot.com/o/badges%2FGB.jpeg?alt=media&token=e4b1b1cd-826e-4f56-a9cc-484180784b21'
          ])
        });
      }
      print(posts);
      print(name);
      print(followers);
      print(following);
      print(wallet);
    });
    return null;
  }

  String fileType = '';
  File file;
  String fileName = '';

  _profilepic() async {
    file = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    Future<File> testCompressAndGetFile(File file, String targetPath) async {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 50,
        rotate: 180,
      );

      print(file.lengthSync());
      print(result.lengthSync());
      setState(() {
        file = result;
      });

      return result;
    }

    fileName = p.basename(file.path);
    setState(() {
      fileName = p.basename(file.path);
    });
    setState(() {
      busy = true;
    });
    StorageReference storageReference;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    storageReference = FirebaseStorage.instance.ref().child("profile/$code");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    Firestore.instance
        .collection('users')
        .document('${widget.user.uid}')
        .updateData({'profile_pic': '$url'});
    data();
    setState(() {
      busy = false;
    });
  }

  delete(index) {
    setState(() {
      busy = true;
    });
    Firestore.instance
        .collection('videos')
        .document(posts[index].toString().replaceAll('/', ','))
        .delete();
    Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .updateData({
      'video': FieldValue.arrayRemove([posts[index]])
    }).then((value) => print('done'));
    data();
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return busy
        ? Scaffold(
            body: Center(
              child: Image.asset(
                'assets/logo.gif',
                height: 200,
                width: 200,
              ),
            ),
          )
        : Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: dark
                        ? LinearGradient(colors: [
                            Color.fromRGBO(5, 23, 48, 10),
                            Color.fromRGBO(5, 23, 48, 10)
                          ])
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(31, 66, 135, 20),
                              Color.fromRGBO(39, 142, 165, 20),
                              Color.fromRGBO(33, 230, 193, 20),
                            ],
                          ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 20),
                        child: Container(child: Image.asset('assets/name.png')),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _profilepic();

                                setState(() {});
                              },
                              child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage('$pic')),
                            ),
                          ),
                          Container(
                            child: Text(
                              name,
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      'Posts',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: dark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  Text(
                                    posts.length.toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        color:
                                            dark ? Colors.white : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Followers',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => View(
                                                    data: followers,
                                                    type: 'Followers',
                                                  )));
                                    },
                                    child: Text(followers.length.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Following',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => View(
                                                    data: following,
                                                    type: 'Following',
                                                  )));
                                    },
                                    child: Text(following.length.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Requests',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Request(
                                                    uid: code,
                                                    data: requests,
                                                    type: 'Requests',
                                                  )));
                                    },
                                    child: Text(requests.length.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: badges.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CircleAvatar(
                                    child: Image.network(badges[index]),
                                    radius: 30,
                                  ));
                            },
                          )),
                      Card(
                        color: Colors.transparent,
                        elevation: 50,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width,
                            child: posts.length == 0
                                ? Center(
                                    child: Text('no posts yet',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black)))
                                : GridView.count(
                                    crossAxisCount: 2,
                                    children:
                                        List.generate(posts.length, (index) {
                                      return Center(
                                        child: GestureDetector(
                                          onLongPress: () {
                                            print(index);

                                            showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      new AlertDialog(
                                                    title: new Text(
                                                        'Are you sure?'),
                                                    content: new Text(
                                                        'Do you want to delete this video'),
                                                    actions: <Widget>[
                                                      new FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Text("NO"),
                                                      ),
                                                      SizedBox(height: 16),
                                                      new FlatButton(
                                                        onPressed: () {
                                                          delete(index);
                                                          print(posts);

                                                          Navigator.of(context)
                                                              .pop(true);
                                                          print(index);
                                                          data();
                                                          setState(() {});
                                                        },
                                                        child: Text("YES"),
                                                      ),
                                                    ],
                                                  ),
                                                ) ??
                                                false;
                                          },
                                          onTap: () {
                                            Firestore.instance
                                                .collection('videos')
                                                .document(posts[index]
                                                    .toString()
                                                    .replaceAll('/', ','))
                                                .get()
                                                .then((value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainPlayer(
                                                              link:
                                                                  value.data)));
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
                                  )),
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: IconButton(
                        icon: Icon(Icons.settings),
                        color: Colors.white,
                        onPressed: () {
                          print(private);
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext bc) {
                                bool da = false;
                                return Settings(
                                  uid: code,
                                  private: private,
                                );
                              });
                        })),
              ],
            ),
          );
  }
}

class Settings extends StatefulWidget {
  final private;
  final uid;

  const Settings({Key key, this.private, this.uid}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState(private, uid);
}

class _SettingsState extends State<Settings> {
  final private;
  bool da;
  final uid;

  _SettingsState(this.private, this.uid);
  @override
  void initState() {
    setState(() {
      da = private;
      print(private);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.3,
      child: new Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Icon(Icons.security),
                  Text(
                    'Private Account',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 100),
                    child: Switch(
                      value: da,
                      onChanged: (value) {
                        setState(() {
                          da = value;
                        });
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({'private': value});
                      },
                      activeTrackColor: Colors.blue,
                      activeColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Icon(Icons.security),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Rewards(),
                        ),
                      );
                    },
                    child: Text(' Rewards',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Icon(Icons.security),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneAuth(),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: Text('Sign Out',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
