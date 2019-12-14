import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_home.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/utils_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingJobDetailsPage extends StatefulWidget {
  const PendingJobDetailsPage({Key key, @required this.jobDetails})
      : super(key: key);

//  final String jobUuid;
  final Job jobDetails;

  _PendingJobDetailsPageState createState() => _PendingJobDetailsPageState();
}

class _PendingJobDetailsPageState extends State<PendingJobDetailsPage> {
  Screen size;

  Job job = Job();
  bool _saving = false;

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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }),
              ],
            );
          },
        ).then((onValue) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
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

  verifyArrivedAtWork() async {
    try {
      setState(() {
        _saving = true;
      });
      Response response;

      Dio dio = new Dio();

      response = await dio.get(Constants.urlVerifyArrivedAtWork + job.uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      setState(() {
        _saving = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          job.verifiedAtWork = DateTime.now().toString();
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

  verifyLeftWork() async {
    try {
      setState(() {
        _saving = true;
      });
      Response response;

      Dio dio = new Dio();

      response = await dio.get(Constants.urlVerifyLeftWork + job.uuid,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json));

      setState(() {
        _saving = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          job.verifiedLeftWork = DateTime.now().toString();
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

    //todo make system ui dark
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColour,
        title: Text("Pending Job Details"),
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
                  jobDetailsAvatar(size),
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
                      buttonVerifiedArrivedAtWork(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonVerifiedFinishedAtWork(),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                      text: "Information:",
                      padding: size.getWidthPx(16),
                      textColor: textPrimaryColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      underline: true),
                  jobInformationWidget()
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Padding jobInformationWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            !Constants.isNullEmptyFalseOrZero(job.workerName)
                ? jobInformationRow('Worker Name', job.workerName)
                : Container(width: 0, height: 0),
            !Constants.isNullEmptyFalseOrZero(job.workerName)
                ? SizedBox(height: 10)
                : Container(width: 0, height: 0),
            !Constants.isNullEmptyFalseOrZero(job.workerCell)
                ? jobInformationRow('Worker Cell', job.workerCell)
                : Container(width: 0, height: 0),
            !Constants.isNullEmptyFalseOrZero(job.workerCell)
                ? SizedBox(height: 10)
                : Container(width: 0, height: 0),
            jobInformationRow('Site', job.site.name),
            SizedBox(height: 10),
            jobInformationRow('Address', job.site.fullAddress.toString()),
            SizedBox(height: 10),
            jobInformationRow('Hours', job.hours.toString()),
            SizedBox(height: 10),
            jobInformationRow('Total Pay', "R ${job.payTotalDay.toString()}"),
            SizedBox(height: 10),
            jobInformationRow(
                'Initial Pay', "R ${job.payPartialDay.toString()}"),
            jobInformationRow(
                'Remaining Pay', "R ${job.payDifferenceDay.toString()}"),
          ],
        ),
      ),
    );
  }

  Row jobInformationRow(jobLabel, jobProperty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Column(
            children: <Widget>[
              Text(jobLabel + ': ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimaryColor)),
              Text(jobProperty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textPrimaryColor))
            ],
          ),
        ),
      ],
    );
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

  Container buttonVerifiedArrivedAtWork() {
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
          "Verify Worker Arrived",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: job.arrivedAtWork != null && job.verifiedAtWork == null ? () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Please Confirm!"),
                content: new Text("Are you sure the worker has arrived?"),
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
                        await verifyArrivedAtWork();
                      }),
                ],
              );
            },
          );
        } : null,
      ),
    );
  }

  Container buttonVerifiedFinishedAtWork() {
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
          "Verify Worker Finished",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: job.arrivedAtWork != null && job.verifiedAtWork != null && job.leftWorkAt != null && job.verifiedLeftWork == null ? () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Please Confirm!"),
                content: new Text("Are you sure the worker has finished?"),
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
                        await verifyLeftWork();
                      }),
                ],
              );
            },
          );
        } : null,
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
