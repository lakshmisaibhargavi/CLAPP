import 'dart:io';

import 'package:CLAP/preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilePage extends StatefulWidget {
  final user;
  final file;
  final filename;

  const FilePage({Key key, this.user, this.file, this.filename})
      : super(key: key);
  @override
  _FilePageState createState() => _FilePageState(file, filename);
}

bool busy = false;

class _FilePageState extends State<FilePage> {
  final file;
  final fileName;
  final snackBar = SnackBar(content: Text('video uploded'));
  String links;

  _FilePageState(this.file, this.fileName);

  Future<void> _uploadFile(
      File file, String filename, List category, links) async {
    setState(() {
      busy = true;
    });

    StorageReference storageReference;
    var time = DateTime.now();
    storageReference = FirebaseStorage.instance.ref().child("videos/$time");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    bool private = true;
    Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .get()
        .then((value) {
      setState(() {
        private = value.data['private'];
      });
    });

    Firestore.instance
        .collection('users')
        .document('${widget.user.uid}')
        .updateData({
      'video': FieldValue.arrayUnion([url])
    }).then((value) {
      Firestore.instance
          .collection('videos')
          .document(url.replaceAll('/', ','))
          .setData({
        'private': private,
        'phone': widget.user.phoneNumber,
        'user': widget.user.uid,
        'url': url,
        'runtime': 0,
        'links': '$links',
        'likes': [],
        'catogory': category
      });

      setState(() {
        busy = false;
      });
      var count = 0;

      Navigator.pop(context, (route) {
        return count++ == 3;
      });

      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  List<String> countList = [
    "#devotional",
    "#comedy",
    "#covid-19",
    "#Fashion",
    "#stunts",
    "#drawing",
    "#electronics",
    "#New_products",
    "#Cars_and_Bikes",
    "#Inspiration",
    "#love",
    "#Telugu",
    "#Tamil",
    "#Hindi",
    "#Hollywood",
    "#Funny",
    "#Marati",
    "#Malyalam",
    "#kannada",
    "#Trend"
  ];
  List<String> selectedCountList = [];

  void _openFilterList() async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: countList,
      height: 480,
      borderRadius: 20,
      headlineText: "Select Count",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedCountList,
    );

    if (list != null) {
      setState(() {
        selectedCountList = List.from(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return busy
        ? Scaffold(
            body: Center(
                child: Image.asset('assets/logo.gif', height: 200, width: 200)),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Upload "),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Preview(
                        link: file,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          links = text;
                        });

                        print(text);
                      },
                      decoration: InputDecoration(
                        labelText: "format:- Shirt:XYZ.com",
                      ),
                      autovalidate: true,
                      autocorrect: true,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Catagery',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                      onPressed: _openFilterList,
                      child: Text('Select Category')),
                  Card(
                    color: Colors.green,
                    child: FlatButton(
                      onPressed: () {
                        _uploadFile(file, fileName, selectedCountList, links);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
