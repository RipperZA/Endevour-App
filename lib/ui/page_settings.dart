import 'package:endevour/services/auth_service.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AuthService appAuth = new AuthService();

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLocalNotification = false;
  bool isPushNotification = true;
  bool isPrivateAccount = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: themeColour,
        title: Text("Settings"),
        brightness: Brightness.light,
      ),
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                accountSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SettingSection accountSection() {
    return SettingSection(
      headerText: "Account".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: TileRow(
            label: "User Name",
            disabled: true,
            rowValue: UserDetails.name,
            disableDivider: false,
            onTap: () {},
          ),
        ),
//        Container(
//          child: TileRow(
//            label: "Change Password",
//            disableDivider: false,
//            onTap: () {},
//          ),
//        )
        Container(
          child: TileRow(
            label: "Log out",
            disableDivider: false,
            onTap: () async {
              await appAuth.logout(context);
            },
          ),
        )
      ],
    );
  }
}
