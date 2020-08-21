import 'package:flutter/material.dart';

class Redeem extends StatefulWidget {
  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 230, 193, 10),
        title: Text(
          'Redeem Your Rewards',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Text(
          'Coming soon',
          style: TextStyle(fontSize: 30),
        )),
      ),
    );
  }
}
