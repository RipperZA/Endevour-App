import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:endevour/model/Job.dart';
import 'package:endevour/model/JobList.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/utils/colors.dart';
import 'package:endevour/utils/responsive_screen.dart';
import 'package:endevour/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
  return Padding(
    padding: EdgeInsets.only(left: leftPadding),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
}

Padding centreAlignText(
    {text, padding, textColor, fontSize, fontWeight, underline = false}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
    child: Align(
      alignment: Alignment.center,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              decoration: underline ? TextDecoration.underline : null,
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
}

Padding rightAlignText({text, rightPadding, textColor, fontSize, fontWeight}) {
  return Padding(
    padding: EdgeInsets.only(right: rightPadding),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(text,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
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
              SizedBox(height: 10),
              jobInformationRow('Site', job.siteName),
              SizedBox(height: 10),
              jobInformationRow(
                  'Address', job.work.first.site.fullAddress.toString()),
              SizedBox(height: 10),
              jobInformationRow(
                  'Work Duration', job.numDays.toStringAsFixed(2) + ' Day(s)'),
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
              jobInformationRow(
                  'Initial Pay', "R ${job.totalPartialPay.toStringAsFixed(2)}"),
              jobInformationRow('Remaining Pay',
                  "R ${job.totalDifferencePay.toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    ),
  );
}

Padding jobInformationWidgetSingle(Job job, Screen size) {
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
              jobInformationRow('Start Date', job.startDate),
              SizedBox(
                height: 10,
              ),
              jobInformationRow('End Date', job.endDate),
              SizedBox(
                height: 10,
              ),
              jobInformationRowCellNumber(
                  'Area Manager',
                  job.areaManagerName +
                      " (${job.areaManagerNumber.toString()})",
                  job.areaManagerNumber),
              SizedBox(height: 10),
              jobInformationRow('Site', job.site.name),
              SizedBox(height: 10),
              jobInformationRow('Address', job.site.fullAddress.toString()),
              SizedBox(height: 10),
              jobInformationRow('Total Hours', job.hours.toString()),
              SizedBox(height: 10),
              jobInformationRow('Total Lunch Duration (Minutes)',
                  job.lunchDuration.toString()),
              SizedBox(height: 10),
              jobInformationRow(
                  'Total Pay', "R ${job.payTotalDay.toStringAsFixed(2)}"),
              SizedBox(height: 10),
              jobInformationRow(
                  'Initial Pay', "R ${job.payPartialDay.toStringAsFixed(2)}"),
              jobInformationRow('Remaining Pay',
                  "R ${job.payDifferenceDay.toStringAsFixed(2)}"),
            ],
          ),
        ),
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
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                    decoration: TextDecoration.underline)),
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

Row jobInformationRowCellNumber(jobLabel, jobProperty, number) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                  size: 20,
                  color: hyperlinkColor,
                ),
                onTap: () {
                  launchNumber(number);
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

getProfilePicture(uuid) async {
  try {
    Response response;

    Dio dio = new Dio();
    response = await dio.get(Constants.urlProfilePicture + '/' + uuid,
        options: Options(
            method: 'GET',
            headers: {'Authorization': 'Bearer ' + UserDetails.token},
            responseType: ResponseType.json // or ResponseType.JSON
            ));

    if (response.statusCode == 200) {
      var profilePicture = response.data['data']['profile_picture'];

      return profilePicture;
    }

    return null;
  } on DioError catch (e) {
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

Row jobInformationRowProfilePicture(jobLabel, jobProperty, Job job, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                  launchNumber(job.workerCell);
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
                  var profilePicture = await getProfilePicture(job.workerUuid);

                  if (profilePicture != null) {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          iconTheme:
                              IconThemeData(color: textPrimaryLightColor),
                          backgroundColor: themeColour,
                          title: Text(
                            job.workerName,
                            style: TextStyle(),
                          ),
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

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo}) : super(key: key);

  final String photo;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = new MemoryImage(base64Decode(photo));

    return Container(
        child: PhotoView(
      imageProvider: imageProvider,
      minScale: 0.25,
      maxScale: 2.0,
    ));
  }
}

launchNumber(number) async {
  var url = "tel://${number}";

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fluttertoast.showToast(
        msg: 'Could not call Area Manager',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: colorErrorMessage,
        textColor: Colors.white,
        fontSize: 16.0);
    throw 'Could not launch $url';
  }
}

Align jobDetailsAvatar(size) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      margin: EdgeInsets.only(top: size.getWidthPx(10)),
      child: CircleAvatar(
        foregroundColor: backgroundColor,
        maxRadius: size.getWidthPx(50),
        backgroundColor: backgroundColor,
        child: CircleAvatar(
          maxRadius: size.getWidthPx(48),
          foregroundColor: backgroundColor,
          backgroundColor: backgroundColor,
          child: Image.asset("assets/icons/job_details.png"),
        ),
      ),
    ),
  );
}
