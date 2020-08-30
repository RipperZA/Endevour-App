import 'package:dio/dio.dart';
import 'package:endevour/ui/page_create_new_job.dart';
import 'package:endevour/ui/page_created_job.dart';
import 'package:endevour/ui/page_dashboard.dart';
import 'package:endevour/ui/page_pending_job.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/bottom_navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentTab = 0;
  PageController pageController;
  List<Widget> tabView = [];
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  void buttonNavigation(dynamic childValue) {
    this.changeCurrentTab(childValue);
  }

  changeCurrentTab(int tab) {
    //Changing tabs from BottomNavigationBar
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(tab);
    });
  }

  versionCheck(context) async {
    try {
      //Get Current installed version of app
      final PackageInfo info = await PackageInfo.fromPlatform();

      double currentVersion = double.parse(
          info.version.trim().replaceAll(".", "") +
              info.buildNumber.trim().replaceAll(".", ""));

      Dio dio = new Dio();
      Response response = await dio.get(Constants.urlVersionInfo,
          options: Options(
              method: 'GET',
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      double newVersion = double.parse(response.data['android']['latest']
          .trim()
          .replaceAll(".", "")
          .replaceAll("+", ""));

      print(currentVersion);
      print(newVersion);

      if (newVersion > currentVersion) {
        _showVersionDialog(context,response);
      }
    } catch (exception) {
      Fluttertoast.showToast(
          msg:
              'Unable to perferm latest app version check. Please confirm you are connected to the internet.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _showVersionDialog(context, response) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of the app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(response.data['android']['url']
                  .trim()),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }

    super.initState();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: bodyView(currentTab),
          bottomNavigationBar: BottomNavBar(
              key: globalKey,
              changeCurrentTab: changeCurrentTab,
              tab: currentTab)),
    );
  }

  bodyView(currentTab) {
    //Current Tabs in Home Screen...

    switch (currentTab) {
      case 0:
        //Dashboard Page
        tabView = [
          DashboardPage(
            buttonNavigation: buttonNavigation,
          )
        ];
        break;
      case 1:
        //Search Page
        tabView = [CreateNewJobPage()];
        break;
      case 2:
        //Profile Page
        tabView = [CreatedJobPage()];
        break;
      case 3:
        tabView = [PendingJobPage()];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }
}
