import 'package:CLAP/dashboard.dart';
import 'package:CLAP/phone.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

//-------------------------intro widget

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        backgroundColor: Colors.black,
        title: "LIGHTS",
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Be the Spotlight",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Arial'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: FittedBox(
            child: Image.asset(
          'assets/light.png',
          height: 200,
          width: 200,
        )),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
      ),
    );
    slides.add(new Slide(
      backgroundColor: Colors.black,
      title: "CAMERA",
      styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'),
      description: "Express Emotions Through Expressions",
      styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontStyle: FontStyle.normal,
          fontFamily: 'Raleway'),
      marginDescription:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      centerWidget: Image.asset(
        'assets/cam.jpg',
        height: 200,
        width: 200,
      ),
    ));
    slides.add(
      new Slide(
        title: "CLAPP",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Make The World Colourful With Your Talent",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Raleway'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Image.asset(
            'assets/final_icon.png',
            height: 200,
            width: 200,
          ),
        ),
        colorBegin: Color.fromRGBO(33, 230, 193, 10),
        colorEnd: Color.fromRGBO(31, 66, 135, 0.8),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
    slides.add(
      new Slide(
        title: "  Earn Rewards And Awards",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Reward for your loyalty in the form of CLAPP COINS,Check the rewards info in the rewards page in profile",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Raleway'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Image.network(
            'http://pngimg.com/uploads/coin/coin_PNG36887.png',
            height: 200,
            width: 200,
          ),
        ),
        colorBegin: Color.fromRGBO(33, 230, 193, 10),
        colorEnd: Color.fromRGBO(31, 66, 135, 0.8),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color.fromRGBO(33, 230, 193, 10),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color.fromRGBO(33, 230, 193, 10),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color.fromRGBO(33, 230, 193, 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33000000),
      highlightColorSkipBtn: Color(0xff000000),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      colorDot: Color(0x33D02090),
      colorActiveDot: Color.fromRGBO(33, 230, 193, 10),
      sizeDot: 13.0,

      // Show or hide status bar
      shouldHideStatusBar: false,
      backgroundColorAllSlides: Colors.grey,
    );
  }
}
