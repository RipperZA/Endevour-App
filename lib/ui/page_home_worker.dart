import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/ui/page_accepted_job.dart';
import 'package:flutter_ui_collections/ui/page_apply_job.dart';
import 'package:flutter_ui_collections/ui/page_create_new_job.dart';
import 'package:flutter_ui_collections/ui/page_dashboard.dart';
import 'package:flutter_ui_collections/widgets/bottom_navigationBar.dart';
import 'package:flutter_ui_collections/widgets/bottom_navigationBar_worker.dart';

import '../main.dart';
import 'page_coming_soon.dart';
import 'page_login.dart';
import 'page_profile.dart';
import 'page_search.dart';
import 'page_settings.dart';
import 'page_signup.dart';

class HomePageWorker extends StatefulWidget {
  @override
  _HomePageWorkerState createState() => _HomePageWorkerState();
}

class _HomePageWorkerState extends State<HomePageWorker> with TickerProviderStateMixin {
  int currentTab = 0;
  PageController pageController;
  List<Widget> tabView = [];
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  void buttonNavigation(dynamic childValue) {
    this.changeCurrentTab(childValue);
    final BottomNavBarWorker navigationBar = globalKey.currentWidget;
//    navigationBar.onTap(childValue);
  }

  changeCurrentTab(int tab) {
    //Changing tabs from BottomNavigationBar
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(tab);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
          body: bodyView(currentTab),
          bottomNavigationBar:
              BottomNavBarWorker(key: globalKey,changeCurrentTab: changeCurrentTab, tab: currentTab)),
    );
  }

  bodyView(currentTab) {
    //Current Tabs in Home Screen...
    switch (currentTab) {
      case 0:
        //Dashboard Page
        tabView = [DashboardPage(buttonNavigation: buttonNavigation,)];
        break;
      case 1:
        //Search Page
        tabView = [ApplyJobPage(changeCurrentTab: changeCurrentTab)];
        break;
      case 2:
        //Profile Page
        tabView = [AcceptedJobPage(changeCurrentTab: changeCurrentTab)];
        break;
      case 3:
        //Setting Page
        tabView = [SettingPage()];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }
}
