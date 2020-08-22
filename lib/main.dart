import 'package:endevour/services/service_locator.dart';
import 'package:endevour/ui/page_splash.dart';
import 'package:flutter/material.dart';

import 'utils/utils.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endevour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColour,
      ),
      home: EndevourApp(),
    );
  }
}

class EndevourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
//          primaryColor: Theme.of(context).primaryColor,
//          primaryColor: themeColour,
//          accentColor: themeColour,
//            hintColor: themeColour,
//        disabledColor: themeColour,
//          inputDecorationTheme : InputDecorationTheme(
//            labelStyle: TextStyle(fontSize: 26, color: Colors.green),
//            enabledBorder: new UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.black),),

//            focusedBorder: new UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.black),) ,
//          )
            ),
        home: SplashScreen());
  }
}
