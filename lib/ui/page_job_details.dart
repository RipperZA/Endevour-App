import 'package:endevour/services/job_service.dart';
import 'package:endevour/model/JobList.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/utils_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage(
      {Key key, @required this.jobDetails, this.viewOnly = false})
      : super(key: key);

  final JobList jobDetails;
  final bool viewOnly;

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  Screen size;
  JobList job;
  bool _saving = false;
  bool viewOnly;

  @override
  void initState() {
    job = widget.jobDetails;
    viewOnly = widget.viewOnly;
    super.initState();
  }

  _launchURL(lat, long) async {
    var url = 'https://www.google.com/maps/search/?api=1&query=' +
        lat.toString() +
        ',' +
        long.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery
        .of(context)
        .size);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColour,
        title: Text("Job Details"),
        brightness: Brightness.light,
      ),
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        child: Stack(
          children: <Widget>[
            AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: backgroundColor,
                systemNavigationBarDividerColor: textSecondary54,
              ),
              child: Container(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[upperPart()],
                  ),
                ),
              ),
            ),
          ],
        ),
        inAsyncCall: _saving,
      ),
    );
  }

  Widget upperPart() {
    return Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
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
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Hours:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                      ' ${job.work[index].hours.toStringAsFixed(
                                          2)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Lunch Duration (Minutes):',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                      ' ${job.work[index].lunchDuration
                                          .toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Total Pay:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                      ' R ${job.work[index].payTotalDay
                                          .toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
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
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
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
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
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
                                style: DefaultTextStyle
                                    .of(context)
                                    .style,
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

  acceptJob() async {
    try {
      setState(() {
        _saving = true;
      });

      await JobService.acceptJob(job, context);

      setState(() {
        _saving = false;
      });
    } catch (e) {
      setState(() {
        _saving = false;
      });
    }
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
              return AlertDialog(
                title: new Text("Please Confirm!"),
                content:
                new Text("Are you sure you want to accept this job?"),
                actions: <Widget>[
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
