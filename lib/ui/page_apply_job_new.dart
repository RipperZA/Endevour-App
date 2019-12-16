import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:endevour/model/WorkList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/model/Work.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_job_details.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyJobPage extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;

  ApplyJobPage({Key key, this.changeCurrentTab}) : super(key: key);

  @override
  _ApplyJobPageState createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  bool _saving = false;
  Screen size;
  Job jobDetails;

  List<WorkList> workList = List();
  List<WorkList> _searchResult = [];

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
//          var work = Work.fromJson(x);

           WorkList work = WorkList.fromJson(x);

           print(work.batch);


          if (this.mounted) {
            setState(() {
              this.workList.add(work);
            });
          }
        }
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
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

  getJobInformation(uuid) async {
    try {
      setState(() {
        _saving = true;
      });
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetJobDetails + uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      setState(() {
        _saving = false;
      });
      if (response.statusCode == 200) {
        var jobInformation = response.data['data']['jobInformation'];

        var job = Job.fromJson(jobInformation);

        if (this.mounted) {
          setState(() {
            this.jobDetails = job;
          });
        }
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
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
      if (work.batch.toLowerCase().contains(text) ||
          work.batch.toLowerCase().contains(text)) _searchResult.add(work);
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
                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Card(
                                      child: new ListTile(
                                        onTap: () async {
                                          await getJobInformation(
                                              workList[i].batch.toString());
                                          if (jobDetails != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailsPage(
                                                          jobDetails:
                                                              jobDetails,
                                                        )));
                                          }
                                        },
                                        leading: CircleAvatar(
                                          child: Text(workList[i].batch[0]),
                                          backgroundColor: themeColour,
                                          foregroundColor: backgroundColor,
                                        ),
                                        title: new Text(_searchResult[i].batch +
                                            ' ' +
                                            _searchResult[i].numItems.toString()),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: '',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Start:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          ' ${_searchResult[i].getElement(2).startDate}'),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: '',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'End:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          ' ${_searchResult[i].getElement(2).endDate}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      margin: const EdgeInsets.all(0.0),
                                    ),
                                  ],
                                );
                              },
                            )
                          : new ListView.builder(
                              itemCount: workList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Card(
                                      child: new ListTile(
                                        onTap: () async {
                                          await getJobInformation(
                                              workList[index].batch.toString());

                                          if (jobDetails != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailsPage(
                                                          jobDetails:
                                                              jobDetails,
                                                        )));
                                          }
                                        },
                                        leading: CircleAvatar(
                                          child: Text(workList[index].batch[0]),
                                          backgroundColor: themeColour,
                                          foregroundColor: backgroundColor,
                                        ),
                                        title: new Text(
                                          workList[index].numItems.toString() +
                                              ' ' +
                                              workList[index].batch,
                                          style: TextStyle(
                                              fontSize: 18,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: '',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Start:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          ' ${workList[index].getElement(0).startDate}'),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: '',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'End:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          ' ${workList[index].getElement(3).endDate}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      margin: const EdgeInsets.all(0.0),
                                    ),
                                  ],
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