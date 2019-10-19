import 'dart:async';
import 'dart:convert';

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/model/Job.dart';
import 'package:flutter_ui_collections/model/Rate.dart';
import 'package:flutter_ui_collections/model/Site.dart';
import 'package:flutter_ui_collections/model/Work.dart';
import 'package:flutter_ui_collections/model/models.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
import 'package:flutter_ui_collections/ui/page_home.dart';
import 'package:flutter_ui_collections/ui/page_home_worker.dart';
import 'package:flutter_ui_collections/ui/page_job_details.dart';
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
import 'package:url_launcher/url_launcher.dart';

class ApplyJobPage extends StatefulWidget {
  @override
  _ApplyJobPageState createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  bool _saving = false;
  Screen size;
  Job jobDetails = Job();

  List<Work> workList = List();
  List<Work> _searchResult = [];

  TextEditingController controller = new TextEditingController();

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

  getJobInformation(uuid) async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetJobDetails + uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      print(22222222);


      if (response.statusCode == 200) {
        var jobInformation = response.data['data']['jobInformation'];

        var job = Job.fromJson(jobInformation);

        print(job.site.name);

        if (this.mounted) {
          setState(() {
            this.jobDetails = job;
          });
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
    getAvailableWork();
    super.initState();
  }

  _launchURL(lat, long) async {
    var url = 'https://www.google.com/maps/search/?api=1&query=' +
        lat.toString() +
        ',' +
        long.toString();
    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  onSearchTextChanged(String text) async {
    setState(() {
      _saving = true;
    });

    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {
        _saving = false;
      });
      return;
    }

    text = text.toLowerCase();

    workList.forEach((work) {
      if (work.name.toLowerCase().contains(text) ||
          work.area.toLowerCase().contains(text)) _searchResult.add(work);
    });

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    Text titleWidget() {
      return Text("Search For Job",
          style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: Colors.white));
    }

    Widget upperPart() {
      return Stack(
        children: <Widget>[
          ClipPath(
            clipper: UpperClipper(),
            child: Container(
              height: size.getWidthPx(110),
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
                    Center(child: titleWidget()),
                    SizedBox(height: size.getWidthPx(10)),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
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
            child: Container(
              child: Container(
                child: Column(
                  children: <Widget>[
                    upperPart(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          onSearchTextChanged(value);
                        },
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                    new Expanded(
                      child: _searchResult.length != 0 ||
                              controller.text.isNotEmpty
                          ? new ListView.builder(
                              itemCount: _searchResult.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return new Card(
                                  child: new ListTile(
                                    onTap: () async {
                                     await getJobInformation(workList[i].uuid.toString());

                                      print(this.jobDetails);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JobDetailsPage(
                                                    jobDetails: jobDetails,
                                                  )));



//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  JobDetailsPage(
//                                                    jobUuid: workList[i].uuid.toString(),
//                                                  )));
//                                      _launchURL(workList[i].latitude,
//                                          workList[i].longitude);
//                                      Navigator.push(
//                                          context, MaterialPageRoute(builder: (context) => JobDetailsPage()));
                                    },
//                                leading: new CircleAvatar(
//                                  backgroundImage: new NetworkImage(
//                                    'https://avatars3.githubusercontent.com/u/17440971?s=400&u=b0d8df93a2e45812e577358cd66849e9d7cf0f90&v=4',
//                                  ),
//                                ),
                                    leading: CircleAvatar(
                                        child: Text(workList[i].name[0])),
                                    title: new Text(_searchResult[i].name +
                                        ' ' +
                                        _searchResult[i].area),
                                    subtitle: Text('Subtitle 1'),
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
                                    onTap: () async {

                                      await getJobInformation(workList[index].uuid.toString());

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JobDetailsPage(
                                                    jobDetails: jobDetails,
                                                  )));


//                                      _launchURL(workList[index].latitude,
//                                          workList[index].longitude);

//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  JobDetailsPage(
//                                                    jobUuid: workList[index].uuid.toString(),
//                                                  )));
                                    },
//                                leading: new CircleAvatar(
//                                  backgroundImage: new NetworkImage(
//                                    'https://avatars3.githubusercontent.com/u/17440971?s=400&u=b0d8df93a2e45812e577358cd66849e9d7cf0f90&v=4',
//                                  ),
//                                ),
                                    leading: CircleAvatar(
                                        child: Text(workList[index].name[0])),
                                    title: new Text(workList[index].name +
                                        ' ' +
                                        workList[index].area),
                                    subtitle: Text('Subtitle 2'),
                                  ),
                                  margin: const EdgeInsets.all(0.0),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
        inAsyncCall: _saving,
      ),
    );
  }
}
