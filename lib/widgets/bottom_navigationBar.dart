import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/utils/utils.dart';

class BottomNavBar extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  int  tab;
  BottomNavBar({Key key, this.changeCurrentTab, this.tab}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
//  int tab = 0;

  Screen size;

  @override
  void initState() {
    super.initState();
    widget.tab = 0;
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: size.getWidthPx(24),
      currentIndex: widget.tab,
      unselectedItemColor: Colors.black45,
      selectedItemColor: colorCurve,
      elevation: 150.0,
      selectedFontSize: 15.0,
      showUnselectedLabels: true,
      onTap: (int index) {
        setState(() {
          if (index != 4) {
            widget.tab = index;
            widget.changeCurrentTab(index);
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: Icon(Icons.home),
          title: Text('Dashboard', style: TextStyle(fontFamily: 'Exo2')),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: Icon(Icons.work),
          title: Text('New Job', style: TextStyle(fontFamily: 'Exo2')),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: Icon(Icons.watch_later),
          title: Text('Pending Jobs', style: TextStyle(fontFamily: 'Exo2')),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: Icon(Icons.settings),
          title: Text('Settings', style: TextStyle(fontFamily: 'Exo2')),
        ),
      ],
    );
  }
}
