import 'dart:async';
import 'dart:convert';

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/model/Rate.dart';
import 'package:flutter_ui_collections/model/Site.dart';
import 'package:flutter_ui_collections/model/Work.dart';
import 'package:flutter_ui_collections/model/models.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
import 'package:flutter_ui_collections/ui/page_home.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/utils/utils.dart' as prefix0;
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ui_collections/utils/data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:calendarro/calendarro.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ApplyJobPage extends StatefulWidget {
  @override
  _ApplyJobPageState createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  List<Work> workList = List();
  List<Work> _searchResult = [];

  TextEditingController controller = new TextEditingController();
  String filter;
  bool _saving = false;

  getAvailableWork() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetAvailableWork,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      if (response.statusCode == 200) {
        var availableWork = response.data['data']['availableWork'];

        for (var x in availableWork) {
          var work = Work.fromJson(x);
          print(work.name);

          if (this.mounted) {
            setState(() {
              this.workList.add(work);
            });
          }
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: json.decode(e.response.data)['error'],
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
    getAvailableWork();
  }

  @override
  Widget build(BuildContext context) {
    onSearchTextChanged(String text) async {
      _searchResult.clear();
      if (text.isEmpty) {
        setState(() {});
        return;
      }

      workList.forEach((work) {
        if (work.name.contains(text) || work.area.contains(text))
          _searchResult.add(work);
      });

      setState(() {});
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        child: Stack(children: <Widget>[
          AnnotatedRegion(
            value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: backgroundColor),
            child: new Column(children: <Widget>[
              new Container(
                color: Theme.of(context).primaryColor,
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
              new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? new ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (context, i) {
                          return new Card(
                            child: new ListTile(
                              leading: new CircleAvatar(
                                backgroundImage: new NetworkImage(
                                  _searchResult[i].uuid,
                                ),
                              ),
                              title: new Text(_searchResult[i].name +
                                  ' ' +
                                  _searchResult[i].area),
                            ),
                            margin: const EdgeInsets.all(0.0),
                          );
                        },
                      )
                    : new ListView.builder(
                        itemCount: workList.length,
                        itemBuilder: (context, index) {
                          return new Card(
                            child: new ListTile(
                              leading: new CircleAvatar(
                                backgroundImage: new NetworkImage(
                                  workList[index].uuid,
                                ),
                              ),
                              title: new Text(workList[index].name +
                                  ' ' +
                                  workList[index].area),
                            ),
                            margin: const EdgeInsets.all(0.0),
                          );
                        },
                      ),
              ),
            ]),
          )
        ]),
        inAsyncCall: _saving,
      ),
    );
  }
}
