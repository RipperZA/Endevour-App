import 'package:endevour/model/Job.dart';
import 'package:endevour/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

Padding jobInformationWidget(Job job) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: backgroundColor,
      elevation: 5,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            children: <Widget>[
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textPrimaryColor,
                    decoration: TextDecoration.underline)),
            SizedBox(
              height: 5,
            ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                            decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              GestureDetector(
                child: Icon(Icons.phone),
                onTap: () {
                  _launchNumber(number);
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textPrimaryColor))
          ],
        ),
      ),
    ],
  );
}

_launchNumber(number) async {
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
