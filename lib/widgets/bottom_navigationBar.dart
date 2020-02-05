import 'package:dio/dio.dart';
import 'package:endevour/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:endevour/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  var notificationArray;
  @override
  void initState() {
    super.initState();
    this.getNotificationCount();
    widget.tab = 0;
  }

  getNotificationCount() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetNotificationCount,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
          ));

      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            this.notificationArray = response.data['data']['notifications'];
          });
        }
      }

      return false;
    } on DioError catch (e) {
      setState(() {
//        _saving = false;
      });
      try {
        Fluttertoast.showToast(
            msg: e.response.data['error'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorErrorMessage,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        Fluttertoast.showToast(
            msg: Constants.standardErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorErrorMessage,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on Error catch (e) {
      Fluttertoast.showToast(
          msg: Constants.standardErrorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
            this.getNotificationCount();
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
          icon: new Stack(
            children: <Widget>[
              new Icon(Icons.create_new_folder),
              notificationArray!=null && notificationArray['created_work_count'] != 0 ? new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '${notificationArray['created_work_count']}',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize:   14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ): SizedBox()
            ],
          ),
          title: Text('Created Jobs', style: TextStyle(fontFamily: 'Exo2')),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: new Stack(
            children: <Widget>[
              new Icon(Icons.watch_later),
              notificationArray!=null && notificationArray['pending_work_count'] != 0 ? new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '${notificationArray['pending_work_count']}',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize:   14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ): SizedBox()
            ],
          ),
          title: Text('Pending Jobs', style: TextStyle(fontFamily: 'Exo2')),
        ),
//        BottomNavigationBarItem(
//          backgroundColor: Colors.grey.shade50,
//          icon: Icon(Icons.settings),
//          title: Text('Settings', style: TextStyle(fontFamily: 'Exo2')),
//        ),
      ],
    );
  }
}
