import 'package:CLAP/clip.dart';
import 'package:CLAP/mainvideo.dart';
import 'package:CLAP/searchprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class Post {
  final data;

  Post(this.data);
}

class _SearchState extends State<Search> {
  List data = [];
  List posts = [];
  int len;
  bool busy = false;

  Future<List> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    var re = await Firestore.instance
        .collection("users")
        .where('name', isEqualTo: search)
        .getDocuments();
    List da = [];
    setState(() {
      data = [];
    });
    re.documents.forEach((element) {
      da.add(element.data);
      setState(() {
        data = da;
      });
    });
    setState(() {
      da = [];
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getdata();
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
      print(element);
      if (element.data['private'] == false) {
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
    return Container(
      height: MediaQuery.of(context).size.height,
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
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBar(
                  searchBarStyle: SearchBarStyle(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  hintText: 'Search by name ',
                  onSearch: search,
                  onItemFound: (data, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchProfile(
                                        user: data,
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black54,
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(data['profile_pic'])),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    data['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      'Discover',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: !busy
                          ? GridView.count(
                              crossAxisCount: 2,
                              children: List.generate(posts.length, (index) {
                                return Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Firestore.instance
                                          .collection('videos')
                                          .document(posts[index]['url']
                                              .toString()
                                              .replaceAll('/', ','))
                                          .get()
                                          .then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainPlayer(
                                                        link: value.data)));
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: AppVideoPlayer(
                                        link: posts[index]['url'],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Image.asset(
                                  'assets/logo.gif',
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
