import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wiki_search/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.grey,
          child: Center(
            child: Text(
              'Wiki',
              style: TextStyle(color: Colors.white, fontSize: 28.0),
            ),
          ),
        ),
      ),
    );
  }
}
