import 'package:dio/dio.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_home_worker.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/utils_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedJobDetailsPage extends StatefulWidget {
  const AcceptedJobDetailsPage({Key key, @required this.jobDetails})
      : super(key: key);

//  final String jobUuid;
  final Job jobDetails;

  _AcceptedJobDetailsPageState createState() => _AcceptedJobDetailsPageState();
}

class _AcceptedJobDetailsPageState extends State<AcceptedJobDetailsPage> {
  Screen size;

  Job job = Job();
  bool _saving = false;
  LocationData currentLocation;
  var location = new Location();

  void initState() {
//    getJobInformation();
    job = widget.jobDetails;

    super.initState();
  }

  cancelJob() async {
    try {
      setState(() {
        _saving = true;
      });

      Response response;

      Dio dio = new Dio();

      response = await dio.get(Constants.urlCancelJob + job.uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      setState(() {
        _saving = false;
      });
      if (response.statusCode == 200) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Success!"),
              content: new Text(response.data['message']),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                RaisedButton.icon(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    icon: Icon(
                      Icons.close,
                      color: imagePrimaryLightColor,
                    ),
                    color: colorSuccessMessage,
                    label: new Text(
                      "Close!",
                      style: TextStyle(
//                              fontFamily: 'Exo2',
                        color: textPrimaryLightColor,
                      ),
                    ),
                    disabledColor: disabledButtonColour,
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePageWorker()));
                    }),
              ],
            );
          },
        ).then((onValue) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePageWorker()));
        }, onError: (err) {
          Navigator.pop(context);
        });
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });

      Fluttertoast.showToast(
          msg: e.response.data['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  arrivedAtWork() async {
    try {
      if (await location.hasPermission() == false) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Enable Location Permission!"),
              content: new Text(
                  "Before you can sign in to work you need to enable your location permission for this app"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                RaisedButton.icon(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    icon: Icon(
                      Icons.close,
                      color: imagePrimaryLightColor,
                    ),
                    color: colorSuccessMessage,
                    label: new Text(
                      "Close!",
                      style: TextStyle(
//                              fontFamily: 'Exo2',
                        color: textPrimaryLightColor,
                      ),
                    ),
                    disabledColor: disabledButtonColour,
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        );
        location.requestPermission();
      } else if (await location.serviceEnabled() == false) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Enable GPS Location!"),
              content: new Text(
                  "Before you can sign in to work you need to enable GPS on your device"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                RaisedButton.icon(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    icon: Icon(
                      Icons.close,
                      color: imagePrimaryLightColor,
                    ),
                    color: colorSuccessMessage,
                    label: new Text(
                      "Close!",
                      style: TextStyle(
//                              fontFamily: 'Exo2',
                        color: textPrimaryLightColor,
                      ),
                    ),
                    disabledColor: disabledButtonColour,
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        );
        location.requestService();
      } else {
        currentLocation = await location.getLocation();
        if (currentLocation == null) {
          Fluttertoast.showToast(
              msg: 'Cannot Find Current Location. Please Try Again',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: colorErrorMessage,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            _saving = true;
          });
          Response response;

          Dio dio = new Dio();

          response = await dio.get(
              Constants.urlArrivedAtWork +
                  job.uuid +
                  '/' +
                  currentLocation.latitude.toString() +
                  '/' +
                  currentLocation.longitude.toString(),
              options: Options(
                  method: 'GET',
                  headers: {'Authorization': 'Bearer ' + UserDetails.token},
                  responseType: ResponseType.json));

          setState(() {
            _saving = false;
          });
          if (response.statusCode == 200) {
            setState(() {
              job.arrivedAtWork = DateTime.now().toString();
            });
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Success!"),
                  content: new Text(response.data['message']),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    RaisedButton.icon(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        icon: Icon(
                          Icons.close,
                          color: imagePrimaryLightColor,
                        ),
                        color: colorSuccessMessage,
                        label: new Text(
                          "Close!",
                          style: TextStyle(
//                              fontFamily: 'Exo2',
                            color: textPrimaryLightColor,
                          ),
                        ),
                        disabledColor: disabledButtonColour,
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          }
        }
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });

      Fluttertoast.showToast(
          msg: e.response.data['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  leftWork() async {
    try {
      if (await location.hasPermission() == false) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Enable Location Permission!"),
              content: new Text(
                  "Before you can sign out of work you need to enable your location permission for this app"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                RaisedButton.icon(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    icon: Icon(
                      Icons.close,
                      color: imagePrimaryLightColor,
                    ),
                    color: colorSuccessMessage,
                    label: new Text(
                      "Close!",
                      style: TextStyle(
//                              fontFamily: 'Exo2',
                        color: textPrimaryLightColor,
                      ),
                    ),
                    disabledColor: disabledButtonColour,
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        );
        location.requestPermission();
      } else if (await location.serviceEnabled() == false) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Enable GPS Location!"),
              content: new Text(
                  "Before you can sign out of work you need to enable GPS on your device"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                RaisedButton.icon(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    icon: Icon(
                      Icons.close,
                      color: imagePrimaryLightColor,
                    ),
                    color: colorSuccessMessage,
                    label: new Text(
                      "Close!",
                      style: TextStyle(
//                              fontFamily: 'Exo2',
                        color: textPrimaryLightColor,
                      ),
                    ),
                    disabledColor: disabledButtonColour,
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        );
        location.requestService();
      } else {
        currentLocation = await location.getLocation();

        if (currentLocation == null) {
          Fluttertoast.showToast(
              msg: 'Cannot Find Current Location. Please Try Again',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: colorErrorMessage,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            _saving = true;
          });
          Response response;

          Dio dio = new Dio();

          response = await dio.get(
              Constants.urlLeftWork +
                  job.uuid +
                  '/' +
                  currentLocation.latitude.toString() +
                  '/' +
                  currentLocation.longitude.toString(),
              options: Options(
                  method: 'GET',
                  headers: {'Authorization': 'Bearer ' + UserDetails.token},
                  responseType: ResponseType.json));

          setState(() {
            _saving = false;
          });
          if (response.statusCode == 200) {
            setState(() {
              job.leftWorkAt = DateTime.now().toString();
            });
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Success!"),
                  content: new Text(response.data['message']),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    RaisedButton.icon(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        icon: Icon(
                          Icons.close,
                          color: imagePrimaryLightColor,
                        ),
                        color: colorSuccessMessage,
                        label: new Text(
                          "Close!",
                          style: TextStyle(
//                              fontFamily: 'Exo2',
                            color: textPrimaryLightColor,
                          ),
                        ),
                        disabledColor: disabledButtonColour,
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          }
        }
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });

      Fluttertoast.showToast(
          msg: e.response.data['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColour,
        title: Text("Accepted Job Details"),
        brightness: Brightness.light,
      ),
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        child: Stack(children: <Widget>[
          AnnotatedRegion(
            value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: backgroundColor,
                systemNavigationBarDividerColor: textSecondary54),
            child: Container(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[upperPart()],
                ),
              ),
            ),
          ),
        ]),
        inAsyncCall: _saving,
      ),
    );
  }

  Widget upperPart() {
    return Stack(children: <Widget>[
//      ClipPath(
//        clipper: UpperClipper(),
//        child: Container(
//          height: size.getWidthPx(80),
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              colors: [colorCurve, colorCurve],
//            ),
//          ),
//        ),
//      ),
      Column(
        children: <Widget>[
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: backgroundColor,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  profileWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      likeWidget(),
                      nameWidget(),
                      followersWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
//          Padding(
//            padding: EdgeInsets.only(
//                top: size.getWidthPx(8),
//                left: size.getWidthPx(20),
//                right: size.getWidthPx(20)),
//            child: Container(height: size.getWidthPx(4), color: colorCurve),
//          ),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: backgroundColor,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  centreAlignText(
                      text: "Actions",
                      padding: size.getWidthPx(16),
                      textColor: textPrimaryColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      underline: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonWidgetCancel(),
                      buttonWidgetNavigate(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonArrivedAtWork(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonFinishedAtWork(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          jobInformationWidget(job, size)
        ],
      )
    ]);
  }

  GestureDetector followerAvatarWidget(String assetIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        maxRadius: size.getWidthPx(24),
        backgroundColor: Colors.transparent,
        child: Image.asset(assetIcon),
      ),
    );
  }

  Container buttonWidgetCancel() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton.icon(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(
          Icons.cancel,
          color: imagePrimaryLightColor,
        ),
        color: colorErrorMessage,
        label: new Text(
          "Cancel Job",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Please Confirm!"),
                content: new Text("Are you sure you want to cancel this job?"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  RaisedButton.icon(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      icon: Icon(
                        Icons.thumb_down,
                        color: imagePrimaryLightColor,
                      ),
                      color: colorErrorMessage,
                      label: new Text(
                        "No!",
                        style: TextStyle(
//                              fontFamily: 'Exo2',
                          color: textPrimaryLightColor,
                        ),
                      ),
                      disabledColor: disabledButtonColour,
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                      }),
                  RaisedButton.icon(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      icon: Icon(
                        Icons.thumb_up,
                        color: imagePrimaryLightColor,
                      ),
                      color: colorSuccessMessage,
                      label: new Text(
                        "Yes!",
                        style: TextStyle(
//                              fontFamily: 'Exo2',
                          color: textPrimaryLightColor,
                        ),
                      ),
                      disabledColor: disabledButtonColour,
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        cancelJob();
                      }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Container buttonWidgetNavigate() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton.icon(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(
          Icons.map,
          color: imagePrimaryLightColor,
        ),
        color: themeColour,
        label: new Text(
          "Navigate",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: () {
          _launchURL(job.site.latitude, job.site.longitude);
        },
      ),
    );
  }

  Container buttonArrivedAtWork() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton.icon(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(
          Icons.location_on,
          color: imagePrimaryLightColor,
        ),
        color: colorSuccessMessage,
        label: new Text(
          "Arrived At Work",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: job.arrivedAtWork == null &&
                job.verifiedAtWork == null &&
                job.leftWorkAt == null &&
                job.verifiedLeftWork == null
            ? () async {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Please Confirm!"),
                      content:
                          new Text("Are you sure you want to sign in to work?"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        RaisedButton.icon(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            icon: Icon(
                              Icons.thumb_down,
                              color: imagePrimaryLightColor,
                            ),
                            color: colorErrorMessage,
                            label: new Text(
                              "No!",
                              style: TextStyle(
//                              fontFamily: 'Exo2',
                                color: textPrimaryLightColor,
                              ),
                            ),
                            disabledColor: disabledButtonColour,
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                            }),
                        RaisedButton.icon(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            icon: Icon(
                              Icons.thumb_up,
                              color: imagePrimaryLightColor,
                            ),
                            color: colorSuccessMessage,
                            label: new Text(
                              "Yes!",
                              style: TextStyle(
//                              fontFamily: 'Exo2',
                                color: textPrimaryLightColor,
                              ),
                            ),
                            disabledColor: disabledButtonColour,
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              await arrivedAtWork();
                            }),
                      ],
                    );
                  },
                );
              }
            : null,
      ),
    );
  }

  Container buttonFinishedAtWork() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton.icon(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(
          Icons.location_off,
          color: imagePrimaryLightColor,
        ),
        color: textSecondaryDarkColor,
        label: new Text(
          "Finished At Work",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: job.arrivedAtWork != null &&
                job.verifiedAtWork != null &&
                job.leftWorkAt == null &&
                job.verifiedLeftWork == null
            ? () async {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Please Confirm!"),
                      content: new Text(
                          "Are you sure you want to sign out of work?"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        RaisedButton.icon(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            icon: Icon(
                              Icons.thumb_down,
                              color: imagePrimaryLightColor,
                            ),
                            color: colorErrorMessage,
                            label: new Text(
                              "No!",
                              style: TextStyle(
//                              fontFamily: 'Exo2',
                                color: textPrimaryLightColor,
                              ),
                            ),
                            disabledColor: disabledButtonColour,
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                            }),
                        RaisedButton.icon(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            icon: Icon(
                              Icons.thumb_up,
                              color: imagePrimaryLightColor,
                            ),
                            color: colorSuccessMessage,
                            label: new Text(
                              "Yes!",
                              style: TextStyle(
//                              fontFamily: 'Exo2',
                                color: textPrimaryLightColor,
                              ),
                            ),
                            disabledColor: disabledButtonColour,
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              await leftWork();
                            }),
                      ],
                    );
                  },
                );
              }
            : null,
      ),
    );
  }

  Align profileWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: size.getWidthPx(10)),
        child: CircleAvatar(
          foregroundColor: backgroundColor,
          maxRadius: size.getWidthPx(50),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            maxRadius: size.getWidthPx(48),
            foregroundColor: colorCurve,
            child: Image.asset("assets/icons/icn_coming_soon.png"),
//            backgroundImage: NetworkImage(
//                'https://avatars3.githubusercontent.com/u/17440971?s=400&u=b0d8df93a2e45812e577358cd66849e9d7cf0f90&v=4'),
          ),
        ),
      ),
    );
  }

  Column likeWidget() {
    return Column(
      children: <Widget>[
        Text("R ${job.payPartialDay}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("Initial Payment",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Column nameWidget() {
    return Column(
      children: <Widget>[
        Text(job.site.name,
//        Text('asdada',
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: colorCurve,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("R ${job.payTotalDay}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Column followersWidget() {
    return Column(
      children: <Widget>[
        Text("R ${job.payDifferenceDay}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("Remaining Pay",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500))
      ],
    );
  }
}
