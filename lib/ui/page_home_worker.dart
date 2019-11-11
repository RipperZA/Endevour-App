import 'package:flutter/material.dart';
import 'package:endevour/ui/page_accepted_job.dart';
import 'package:endevour/ui/page_apply_job.dart';
import 'package:endevour/ui/page_dashboard_worker.dart';
import 'package:endevour/widgets/bottom_navigationBar_worker.dart';

import 'page_settings.dart';

class HomePageWorker extends StatefulWidget {
  @override
  _HomePageWorkerState createState() => _HomePageWorkerState();
}

class _HomePageWorkerState extends State<HomePageWorker>
    with TickerProviderStateMixin {
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: bodyView(currentTab),
          bottomNavigationBar: BottomNavBarWorker(
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
          DashboardPageWorker(
            buttonNavigation: buttonNavigation,
          )
        ];
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
