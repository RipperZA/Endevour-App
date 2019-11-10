import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/services/auth_service.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

AuthService appAuth = new AuthService();

class DashboardPage extends StatefulWidget {
  final Function(dynamic a) buttonNavigation;

  DashboardPage({Key key, @required this.buttonNavigation}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Screen size;
  int _selectedIndex = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  var _isPasswordValid = false;

  buttonNavigation(index) {
    widget.buttonNavigation(index);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (this.mounted) {
      if (UserDetails.verified == false) {
        WidgetsBinding.instance.scheduleFrameCallback((_) async {
          await showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => _buildAboutDialog(context));
        });
      }
    }
    passwordController.addListener(validPassword);
  }

  updatePassword() async {
    try {
      bool _result = await appAuth.updatePassword(this.passwordController.text);

      if (_result) {}
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
    }
  }

  validPassword() {
    if (passwordController.text.length >= 4) {
      setState(() {
        _isPasswordValid = true;
      });
    } else {
      setState(() {
        _isPasswordValid = false;
      });
    }
  }

  _buildAboutDialog(BuildContext context) {
    String validatePassword(String value) {
      if (value.length < 5)
        return 'Password must be more than 5 charaters';
      else
        return null;
    }

    return AlertDialog(
      title: const Text('Please Update Your Password'),
      content: SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autovalidate: true,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: false,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: FlatButton(
                onPressed: _isPasswordValid == true
                    ? () {
                        print(passwordController.text);

                        this.updatePassword();
                        Navigator.of(context).pop();
                      }
                    : null,
                disabledColor: disabledButtonColour,
                textColor: textPrimaryLightColor,
                color: themeColour,
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[],
    );
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
                  SizedBox(height: size.getWidthPx(70)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                propertyCard('icons/new_job.png', 'New Job', 1),
                propertyCard('icons/profile.png', 'History', 0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                propertyCard('icons/open_jobs.png', 'Pending Jobs', 2),
                propertyCard('icons/imgforgot.png', 'Settings', 3),
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
              width: size.getWidthPx(110),
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
