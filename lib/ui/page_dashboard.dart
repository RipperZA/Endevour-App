import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/model/models.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
import 'package:flutter_ui_collections/ui/page_create_new_job.dart';
import 'package:flutter_ui_collections/ui/page_home.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  final Function(dynamic a) buttonNavigation;

  DashboardPage({Key key, @required this.buttonNavigation}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Screen size;
  int _selectedIndex = 1;

  buttonNavigation(index) {
    widget.buttonNavigation(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    premiumList
//    ..add(Property(propertyName:"Omkar Lotus", propertyLocation:"Ahmedabad ", image:"feature_1.jpg", propertyPrice:"26.5 Cr"))
//    ..add(Property(propertyName:"Sandesh Heights", propertyLocation:"Baroda ", image:"feature_2.jpg", propertyPrice:"11.5 Cr"))
//    ..add(Property(propertyName:"Sangath Heights", propertyLocation:"Pune ", image:"feature_3.jpg", propertyPrice:"19.0 Cr"))
//    ..add(Property(propertyName:"Adani HighRise", propertyLocation:"Mumbai ", image:"hall_1.jpg", propertyPrice:"22.5 Cr"))
//    ..add(Property(propertyName:"N.G Tower", propertyLocation:"Gandhinagar ", image:"hall_2.jpeg", propertyPrice:"7.5 Cr"))
//    ..add(Property(propertyName:"Vishwas CityRise", propertyLocation:"Pune ", image:"hall_1.jpg", propertyPrice:"17.5 Cr"))
//    ..add(Property(propertyName:"Gift City", propertyLocation:"Ahmedabad ", image:"hall_2.jpeg", propertyPrice:"13.5 Cr"))
//    ..add(Property(propertyName:"Velone City", propertyLocation:"Mumbai ", image:"feature_1.jpg", propertyPrice:"11.5 Cr"))
//    ..add(Property(propertyName:"PabelBay", propertyLocation:"Ahmedabad ", image:"hall_1.jpg", propertyPrice:"33.1 Cr"))
//    ..add(Property(propertyName:"Sapath Hexa Tower", propertyLocation:"Ahmedabad", image:"feature_3.jpg", propertyPrice:"15.6 Cr"));
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[upperPart()],
            ),
          ),
        ),
      ),
    );
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(140),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurveSecondary],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(36)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(100)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                propertyCard('feature_2.jpg', 'Profile', 2),
                propertyCard('feature_1.jpg', 'History', 0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                propertyCard('feature_3.jpg', 'Open Jobs', 3),
                propertyCard('hall_1.jpg', 'New Job', 1),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Text titleWidget() {
    return Text("Welcome, " + UserDetails.name,
        style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.white));
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Padding centerAlignText(
      {text, centerPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: centerPadding),
      child: Align(
        alignment: Alignment.center,
        child: Text(text ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  GestureDetector propertyCard(String imageName, String cardTitle, int page) {
    return GestureDetector(
      onTap: () => {
        this.buttonNavigation(page),
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => CreateNewJobPage()))
      },
      child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          borderOnForeground: true,
          child: Container(
              height: size.getWidthPx(120),
              width: size.getWidthPx(150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      child:
                          Image.asset('assets/$imageName', fit: BoxFit.fill)),
                  SizedBox(height: size.getWidthPx(8)),
                  centerAlignText(
                      text: "$cardTitle",
                      centerPadding: size.getWidthPx(8),
                      textColor: colorCurve,
                      fontSize: 14.0),
                ],
              ))),
    );
  }

  Padding buildChoiceChip(index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? backgroundColor : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
