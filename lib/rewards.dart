import 'package:flutter/material.dart';

class Rewards extends StatefulWidget {
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 230, 193, 10),
        title: Text(
          'Rewards Info',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  '*  Reward for your loyalty in the form of CLAPP COINS \n* Minimum 500 followers \n* 1 Growth booster badge (minimum 15 referral)/n* User should have minimum 200 likes per video\n* 1 like = 1 CLAPP COIN',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '* Referral codes - 100 CLAPP coins for new user and 50 CLAPP coins for the inviting user\n* Redeeming criteria - Can be redeemed only after a minimum of 1000 clap coins',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '*  Badges - Levels like Brass, Bronze, Silver, Gold in\n * Best referrer - Growth booster \n*  (15 - Referrals)\n* Active Performer - Clapptron\n* (15 minutes per day)\n* Creator - Spotlight\n* ([Number of videos * likes]/ 7 [ie.per week])',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '      * ([Number of videos * likes]/ 7 [ie.per week])\n*  Titles  \n* CLAPP of the week - most liked video in a week \n* CLAPP of the month - most like video in a month \n* CLAPP icon - highest followed person with regular interactions\n*  Special appreciation for maintaining streaks & Bonus gifts based on contests',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
