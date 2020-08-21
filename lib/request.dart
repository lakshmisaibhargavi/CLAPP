import 'package:CLAP/searchprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  final type;
  final data;
  final uid;

  const Request({Key key, this.type, this.data, this.uid}) : super(key: key);
  @override
  _RequestState createState() => _RequestState(type, data, uid);
}

class _RequestState extends State<Request> {
  final uid;
  final type;
  final List data;
  List values = [];
  bool busy = false;

  _RequestState(this.type, this.data, this.uid);

  getdata() async {
    setState(() {
      busy = true;
      values = [];
    });
    print(data);
    if (data.length > 0) {
      var re = await Firestore.instance
          .collection("users")
          .where('url', whereIn: data)
          .getDocuments();

      re.documents.forEach((element) {
        print(element.data);
        values.add(element.data);
      });
    }
    print(values);
    setState(() {
      busy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Widget build(BuildContext context) {
    return !busy
        ? Scaffold(
            appBar: AppBar(
              title: Text(type),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(31, 66, 135, 20),
                    Color.fromRGBO(39, 142, 165, 20),
                    Color.fromRGBO(33, 230, 193, 20),
                  ],
                ),
              ),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchProfile(
                                          user: values[index],
                                        )));
                          },
                          child: Container(
                            color: Colors.black54,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          values[index]['profile_pic'])),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 30),
                                      child: Container(
                                          child: Text(
                                        values[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      Firestore.instance
                                          .collection('users')
                                          .document(values[index]['url'])
                                          .updateData({
                                        'following':
                                            FieldValue.arrayUnion([uid])
                                      });
                                      Firestore.instance
                                          .collection('users')
                                          .document(uid)
                                          .updateData({
                                        'followers': FieldValue.arrayUnion(
                                            [values[index]['url']])
                                      });
                                      Firestore.instance
                                          .collection('users')
                                          .document(uid)
                                          .updateData({
                                        'requests': FieldValue.arrayRemove(
                                            [values[index]['url']])
                                      });
                                      setState(() {
                                        values.removeAt(index);
                                      });
                                    },
                                    child: Text('Accept'),
                                    color: Colors.white,
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Firestore.instance
                                        .collection('users')
                                        .document(uid)
                                        .updateData({
                                      'requests': FieldValue.arrayRemove(
                                          [values[index]['url']])
                                    });
                                    setState(() {
                                      values.removeAt(index);
                                    });
                                  },
                                  child: Text('decline'),
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: values.length),
            ))
        : Scaffold(
            body: Center(
              child: Image.asset(
                'assets/logo.gif',
                height: 200,
                width: 200,
              ),
            ),
          );
  }
}
