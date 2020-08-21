import 'package:CLAP/searchprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class View extends StatefulWidget {
  final type;
  final data;

  const View({Key key, this.type, this.data}) : super(key: key);
  @override
  _ViewState createState() => _ViewState(type, data);
}

class _ViewState extends State<View> {
  final type;
  final data;
  List values = [];
  bool busy = false;

  _ViewState(this.type, this.data);

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
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(5, 23, 48, 10),
                Color.fromRGBO(5, 23, 48, 10)
              ])),
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
                                    Container(
                                        child: Text(
                                      values[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                    Text('ID:  ' + values[index]['url'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10))
                                  ],
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
