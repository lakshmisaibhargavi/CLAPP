import 'package:CLAP/opt_signup.dart';
import 'package:CLAP/otp_screen.dart';
import 'package:CLAP/tc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isValid = false;
  String name;
  String ref;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
            StatefulBuilder(builder: (BuildContext context, StateSetter state) {
          return Container(
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
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/final_icon.png',
                  height: 150,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  autofocus: false,
                  onChanged: (text) {
                    validate(state);
                  },
                  decoration: InputDecoration(
                    labelText: "10 digit mobile number",
                    prefix: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "+91",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  autovalidate: true,
                  autocorrect: false,
                  maxLengthEnforced: true,
                  validator: (value) {
                    return !isValid
                        ? 'Please provide a valid 10 digit phone number'
                        : null;
                  },
                ),
                TextFormField(
                  onChanged: (text) {
                    validate(state);
                    setState(() {
                      name = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Input Name",
                  ),
                  autovalidate: true,
                  autocorrect: true,
                  validator: (value) {
                    return value == null ? 'Please enter name' : null;
                  },
                ),
                TextFormField(
                  onChanged: (text) {
                    setState(() {
                      ref = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Input Referalcode",
                  ),
                  autovalidate: true,
                  autocorrect: true,
                  validator: (value) {
                    return value == null ? 'Please enter referalcode' : null;
                  },
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                          value: checkBoxValue,
                          activeColor: Colors.green,
                          onChanged: (bool newValue) {
                            setState(() {
                              checkBoxValue = newValue;
                            });
                          }),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Terms(),
                                ));
                          },
                          child: Text('I Have Agreed To Terms and Conditions')),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: RaisedButton(
                        color: !isValid ? Colors.redAccent : Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Text(
                          (!isValid) ? "ENTER PHONE NUMBER" : "CONTINUE",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (isValid && checkBoxValue) {
                            print(name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OTP(
                                      ref: ref,
                                      mobileNumber: _phoneNumberController.text,
                                      name: name),
                                ));
                          } else {
                            validate(state);
                          }
                        },
                        padding: EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
