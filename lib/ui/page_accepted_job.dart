import 'package:dio/dio.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/model/WorkList.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_accepted_job_details.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedJobPage extends StatefulWidget {

  @override
  _AcceptedJobPageState createState() => _AcceptedJobPageState();
}

class _AcceptedJobPageState extends State<AcceptedJobPage> {
  bool _saving = false;
  Screen size;
  Job jobDetails;

  List<WorkList> workList = List();
  List<WorkList> _searchResult = [];

  TextEditingController controller = new TextEditingController();

  getAcceptedWork() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlAcceptedJobs,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      if (response.statusCode == 200) {
        var availableWork = response.data['data']['acceptedWork'];

        for (var x in availableWork) {
          WorkList work = WorkList.fromJson(x);

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
      response = await dio.get(Constants.urlGetJobDetailsSingle + uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      setState(() {
        _saving = false;
      });
      if (response.statusCode == 200) {
        var jobInformation = response.data['data']['jobInformation'];

        Job job = Job.fromJson(jobInformation);

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
    getAcceptedWork();
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
    workList.forEach((workList) {
      if (workList.siteName.toLowerCase().contains(text) ||
          workList.area.toLowerCase().contains(text)) {
        _searchResult.add(workList);
      }
    });

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    Text titleWidget() {
      return Text("Accepted Jobs",
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
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 3,
                                    ),
                                    new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              _searchResult[index].work.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, position) {
                                            return ListTile(
                                              onTap: () async {
                                                await getJobInformation(
                                                    _searchResult[index]
                                                        .work[position]
                                                        .uuid
                                                        .toString());

                                                if (jobDetails != null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AcceptedJobDetailsPage(
                                                                jobDetails:
                                                                    jobDetails,
                                                              )));
                                                }
                                              },
                                              leading: CircleAvatar(
                                                child: Text(_searchResult[index]
                                                    .work[position]
                                                    .name[0]),
                                                backgroundColor: themeColour,
                                                foregroundColor:
                                                    backgroundColor,
                                              ),
                                              title: new Text(
                                                  _searchResult[index]
                                                          .work[position]
                                                          .name +
                                                      ' ' +
                                                      _searchResult[index]
                                                          .work[position]
                                                          .area),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'Start:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' ${_searchResult[index].work[position].startDate}'),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'End:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' ${_searchResult[index].work[position].endDate}'),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                'Day ${_searchResult[index].work[position].current_day} of ${_searchResult[index].work[position].total_days}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      margin: const EdgeInsets.all(0.0),
                                    ),
                                    SizedBox(
                                      height: 3,
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
                                      height: 3,
                                    ),
                                    new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              workList[index].work.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, position) {
                                            return ListTile(
                                              onTap: () async {
                                                await getJobInformation(
                                                    workList[index]
                                                        .work[position]
                                                        .uuid
                                                        .toString());

                                                if (jobDetails != null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AcceptedJobDetailsPage(
                                                                jobDetails:
                                                                    jobDetails,
                                                              )));
                                                }
                                              },
                                              leading: CircleAvatar(
                                                child: Text(workList[index]
                                                    .work[position]
                                                    .name[0]),
                                                backgroundColor: themeColour,
                                                foregroundColor:
                                                    backgroundColor,
                                              ),
                                              title: new Text(workList[index]
                                                      .work[position]
                                                      .name +
                                                  ' ' +
                                                  workList[index]
                                                      .work[position]
                                                      .area),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'Start:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' ${workList[index].work[position].startDate}'),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'End:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' ${workList[index].work[position].endDate}'),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                'Day ${workList[index].work[position].current_day} of ${workList[index].work[position].total_days}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      margin: const EdgeInsets.all(0.0),
                                    ),
                                    SizedBox(
                                      height: 3,
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
