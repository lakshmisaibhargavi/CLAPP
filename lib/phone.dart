import 'package:CLAP/otp_screen.dart';
import 'package:CLAP/signup.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

  oncheck() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you have an existing acccount?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new FlatButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OTPScreen(
                    mobileNumber: _phoneNumberController.text,
                  ),
                )),
            child: Text("YES"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(builder: (BuildContext context, StateSetter state) {
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
          padding: EdgeInsets.only(top: 100, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/final_icon.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Text(
                    'LOGIN',
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
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
                        ? 'Please enter a valid 10 digit phone number'
                        : null;
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: RaisedButton(
                        elevation: 20,
                        color: !isValid ? Colors.red[400] : Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Text(
                          !isValid ? "ENTER PHONE NUMBER" : "CONTINUE",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (isValid) {
                            oncheck();
                          } else {
                            validate(state);
                          }
                        },
                        padding: EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup(),
                        ));
                  },
                  child: Text(
                    'Create a new Account',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
