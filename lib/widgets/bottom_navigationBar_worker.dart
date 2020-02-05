import 'package:dio/dio.dart';
import 'package:endevour/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:endevour/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomNavBarWorker extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
   int tab;

  BottomNavBarWorker({Key key, this.changeCurrentTab, this.tab}) : super(key: key);

  @override
  _BottomNavBarWorkerState createState() => _BottomNavBarWorkerState();
}

class _BottomNavBarWorkerState extends State<BottomNavBarWorker>
    with SingleTickerProviderStateMixin {
//  int tab = 0;

  Screen size;
  var notificationArray;


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

      print(response);

      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            this.notificationArray = response.data['data']['notifications'];
            print(notificationArray);

          });
        }
      }

      return false;
    } on DioError catch (e) {
      print(e);

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
        print(e);

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
      print(e);

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
  void initState() {
    super.initState();
    this.getNotificationCount();
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
          if (index <= 3) //index goes from 0-3 in page_home_worker.dart
          {
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
          icon: new Stack(
            children: <Widget>[
              new Icon(Icons.work),
              notificationArray!=null && notificationArray['available_work_count'] != 0 ? new Positioned(
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
                    '${notificationArray['available_work_count']}',
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
          title: Text('Apply', style: TextStyle(fontFamily: 'Exo2')),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey.shade50,
          icon: new Stack(
            children: <Widget>[
              new Icon(Icons.watch_later),
              notificationArray!=null && notificationArray['accepted_work_count'] != 0 ? new Positioned(
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
                    '${notificationArray['accepted_work_count']}',
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
          icon: Icon(Icons.settings),
          title: Text('Settings', style: TextStyle(fontFamily: 'Exo2')),
        ),
      ],
    );
  }
}
