import 'package:endevour/ui/page_create_new_job.dart';
import 'package:endevour/ui/page_created_job.dart';
import 'package:endevour/ui/page_dashboard.dart';
import 'package:endevour/ui/page_pending_job.dart';
import 'package:endevour/widgets/bottom_navigationBar.dart';
import 'package:flutter/material.dart';

import 'page_settings.dart';

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
    final BottomNavBar navigationBar = globalKey.currentWidget;
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
        //Setting Page
        tabView = [PendingJobPage()];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }
}
