import 'package:dio/dio.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/model/JobList.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_home_worker.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/utils_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage(
      {Key key, @required this.jobDetails, this.viewOnly = false})
      : super(key: key);

//  final String jobUuid;
  final JobList jobDetails;
  final bool viewOnly;

  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  Screen size;

  JobList job;
  bool _saving = false;
  bool viewOnly;

  void initState() {
//    getJobInformation();
    job = widget.jobDetails;
    viewOnly = widget.viewOnly;

    super.initState();
  }

  acceptJob() async {
    try {
      setState(() {
        _saving = true;
      });

      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlAcceptJob + job.batch,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColour,
        title: Text("Job Details"),
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
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
//              color: backgroundColor,
              elevation: 5,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      jobDetailsAvatar(size),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          likeWidget(),
                          Flexible(child: nameWidget()),
                          followersWidget(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.getWidthPx(8),
                            left: size.getWidthPx(20),
                            right: size.getWidthPx(20)),
                        child: Container(
                            height: size.getWidthPx(4), color: colorCurve),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buttonWidgetAccept(),
                          buttonWidgetNavigate(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
//
          jobInformationWidget(job, size),
          this.viewOnly == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 10,
                      child: Text(''),
                      backgroundColor: colorLightRed,
                      foregroundColor: backgroundColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Red Indicates which days were cancelled",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
//              height: size.getWidthPx(300),
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: job.work.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Card(
//                          color: backgroundColor,
                      elevation: 5,
                      color: job.work[index].cancelledAt != null
                          ? colorLightRed
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: new ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                          backgroundColor: themeColour,
                          foregroundColor: backgroundColor,
                        ),
                        title: new Text(
                          'Day ' + (index + 1).toString(),
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Hours:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' ${job.work[index].hours.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Lunch Duration (Minutes):',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' ${job.work[index].lunchDuration.toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Pay:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' R ${job.work[index].payTotalDay.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Initial Pay Day ' +
                                          (index + 1).toString() +
                                          ':',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' R ${job.work[index].payPartialDay}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Work Done Pay Day ' +
                                          (index + 1).toString() +
                                          ':',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' R ${job.work[index].payDifferenceDay}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Start:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' ${job.work[index].startDate}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'End:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' ${job.work[index].endDate}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      margin: const EdgeInsets.all(0.0),
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      )
    ]);
  }

  Padding jobInformationWidget(JobList job, Screen size) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
//      color: backgroundColor,
        elevation: 5,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Column(
              children: <Widget>[
                centreAlignText(
                    text: "Job Overview",
                    padding: size.getWidthPx(16),
                    textColor: textPrimaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    underline: true),
                SizedBox(
                  height: 15,
                ),
                jobInformationRow('Start Date', job.work.first.startDate),
                SizedBox(
                  height: 10,
                ),
                jobInformationRow('End Date', job.work.last.endDate),
                SizedBox(
                  height: 10,
                ),
                jobInformationRowCellNumber(
                    'Area Manager',
                    job.work.first.areaManagerName +
                        " (${job.work.first.areaManagerNumber.toString()})",
                    job.work.first.areaManagerNumber),
                this.viewOnly == true ? SizedBox(height: 10) : Container(),
                this.viewOnly == true
                    ? jobInformationRowProfilePicture(
                        'Worker Cell',
                        job.work.first.worker.cellNumber,
                        job.work.first,
                        context)
                    : Container(),
                SizedBox(height: 10),
                jobInformationRow('Site', job.siteName),
                SizedBox(height: 10),
                jobInformationRow(
                    'Address', job.work.first.site.fullAddress.toString()),
                SizedBox(height: 10),
                jobInformationRow('Work Duration',
                    job.numDays.toStringAsFixed(2) + ' Day(s)'),
                SizedBox(height: 10),
                jobInformationRow(
                    'Total Hours', job.totalHours.toStringAsFixed(2)),
                SizedBox(height: 10),
                jobInformationRow('Total Lunch (Minutes)',
                    job.totalLunchDuration.toStringAsFixed(0)),
                SizedBox(height: 10),
                jobInformationRow(
                    'Total Pay', "R ${job.totalPay.toStringAsFixed(2)}"),
                SizedBox(height: 10),
                jobInformationRow('Initial Pay',
                    "R ${job.totalPartialPay.toStringAsFixed(2)}"),
                jobInformationRow('Remaining Pay',
                    "R ${job.totalDifferencePay.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row jobInformationRowProfilePicture(jobLabel, jobProperty, Job job, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '',
                        children: <TextSpan>[
                          TextSpan(
                              text: jobLabel + "  ",
                              style: TextStyle(
                                  fontFamily: 'Exo2',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.phone,
                        size: 26,
                        color: hyperlinkColor,
                      ),
                      onTap: () {
                        launchNumber(job.worker.cellNumber);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.face,
                        size: 26,
                        color: hyperlinkColor,
                      ),
                      onTap: () async {
                        var profilePicture =
                            await getProfilePicture(job.worker.uuid);

                        if (profilePicture != null) {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor: themeColour,
                                title:
                                    Text(job.worker.name + job.worker.surname),
                                brightness: Brightness.light,
                              ),
                              body: Center(
                                child: PhotoHero(
                                  photo: profilePicture,
                                ),
                              ),
                            );
                          }));
                        }
                      },
                    )
                  ]),
              SizedBox(
                height: 5,
              ),
              Text(jobProperty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textPrimaryColor))
            ],
          ),
        ),
      ],
    );
  }

  Container buttonWidgetAccept() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton.icon(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(
          Icons.thumb_up,
          color: imagePrimaryLightColor,
        ),
        color: colorSuccessMessage,
        label: new Text(
          "Accept Job",
          style: TextStyle(
//                              fontFamily: 'Exo2',
            color: textPrimaryLightColor,
          ),
        ),
        disabledColor: disabledButtonColour,
        onPressed: this.viewOnly == false
            ? () async {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Please Confirm!"),
                      content:
                          new Text("Are you sure you want to accept this job?"),
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
                              acceptJob();
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
          _launchURL(
              job.work.first.site.latitude, job.work.first.site.longitude);
        },
      ),
    );
  }

  Column likeWidget() {
    return Column(
      children: <Widget>[
        Text("R ${job.totalPartialPay.toStringAsFixed(2)}",
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
        Text(job.siteName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: colorCurve,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("R ${job.totalPay.toStringAsFixed(2)}",
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
        Text("R ${job.totalDifferencePay.toStringAsFixed(2)}",
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
