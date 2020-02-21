import 'dart:async';

import 'package:endevour/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page_login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Screen size;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      navigateFromSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        body: Center(
            child: Container(
//                width: size.getWidthPx(300),
//                height: size.getWidthPx(300),
                child: Image.asset("assets/icons/logo_splash.png"))));
  }

  Future navigateFromSplash() async {

    //every time the app opens up and splash screen shows. Set this to true
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.loggingIn, true);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);

//    String isOnBoard = await LocalStorage.sharedInstance.readValue(Constants.isOnBoard);
//
//    print("isOnBoard  $isOnBoard");
//      if(isOnBoard == null || isOnBoard == "0"){
//        //Navigate to OnBoarding Screen.
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
//      }else{
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
//      }
  }
}
