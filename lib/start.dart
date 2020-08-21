import 'dart:math';

import 'package:CLAP/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class Start extends StatefulWidget {
  final camera;
  static final style = TextStyle(
      fontSize: 30,
      fontFamily: "Billy",
      fontWeight: FontWeight.w600,
      color: Colors.white);

  const Start({Key key, this.camera}) : super(key: key);

  @override
  _StartState createState() => _StartState(camera);
}

class _StartState extends State<Start> {
  final camera;
  int page = 0;
  bool end = false;
  LiquidController liquidController;
  UpdateType updateType;

  _StartState(this.camera);

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Image.asset(
            'assets/light.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Text(
                "LIGHTS",
                style: Start.style,
              ),
              Text(
                "Be the Spotlight",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Image.asset(
            'assets/cam.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "CAMERA",
                  style: Start.style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  "Express Emotions Through Expressions",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            height: 300,
            width: 300,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
            child: Column(
              children: <Widget>[
                Text(
                  "Earn Rewards And Awards",
                  style: Start.style,
                ),
                Text(
                  "Reward for your loyalty in the form of CLAPP COINS,Check the rewards info in the rewards page in profile",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(33, 230, 193, 20),
            Color.fromRGBO(39, 142, 165, 20),
            Color.fromRGBO(31, 66, 135, 20),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.network(
            'http://pngimg.com/uploads/coin/coin_PNG36887.png',
            height: 300,
            width: 300,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
            child: Column(
              children: <Widget>[
                Text(
                  "Earn Rewards And Awards",
                  style: Start.style,
                ),
                Text(
                  "Reward for your loyalty in the form of CLAPP COINS,Check the rewards info in the rewards page in profile",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              enableSlideIcon: true,
              enableLoop: false,
              pages: pages,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(pages.length, _buildDot),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    if (end == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                    liquidController.animateToPage(
                        page: pages.length - 1, duration: 500);
                    if (pages.length == liquidController.currentPage + 1) {
                      print('hello');
                      setState(() {
                        end = true;
                      });
                    } else {
                      setState(() {
                        end = false;
                      });
                    }
                  },
                  child: Text(
                    end ? "Done" : "Skip to End",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.jumpToPage(
                        page: liquidController.currentPage + 1);
                    if (pages.length == liquidController.currentPage + 1) {
                      print('hello');
                      if (end == true) {
                        print('home');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }

                      setState(() {
                        end = true;
                      });
                    } else {
                      setState(() {
                        end = false;
                      });
                    }
                  },
                  child: Text(end ? '' : "Next",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
    if (end == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if (pages.length == liquidController.currentPage + 1) {
      setState(() {
        end = true;
      });
    } else {
      setState(() {
        end = false;
      });
    }
  }
}
