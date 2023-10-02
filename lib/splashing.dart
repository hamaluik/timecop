// all apis here

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timecop/screens/dashboard/DashboardScreen.dart';

class Splashing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<Splashing> {



  @override
  void initState() {
    super.initState();
    whereToGo();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00ffff), Color(0xFFFFFFFF)]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              "icon1.png",
              height: 300,
              width: 300,
            ),
            const Text(
              "LOADING TIME COP..",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,

                color: Colors.white,
              ),
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  void whereToGo() async {

        Timer(Duration(seconds: 7), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
        });

    }

}
