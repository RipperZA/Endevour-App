// -----------------------------------------------------------------------------
// This file contains import statements for various packages and modules.
// It also declares a class JobService with static methods for job acceptance.
// -----------------------------------------------------------------------------

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/model/JobList.dart';
import 'package:endevour/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/job_details_bloc.dart';

// -----------------------------------------
// JobService - Service class for job actions
// -----------------------------------------
class JobService {

  // The URL for job acceptance
  static final String _jobAcceptanceURL = Constants.urlAcceptJob;

  // This function performs the job acceptance action
  static Future<void> acceptJob(JobList job, BuildContext context, JobDetailsBloc bloc) async {
    try {

      Response response;
      Dio dio = Dio();
      response = await dio.get(
        '$_jobAcceptanceURL${job.batch}',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer ${UserDetails.token}'},
          responseType: ResponseType.json,
        ),
      );
      dio.clear();
      if (response.statusCode == 200) {
        await _showSuccessDialog(context, response.data['message'], bloc);
      }
    } on DioError catch (e) {
      _showToast(e.response?.data['error'] ?? Constants.standardErrorMessage);
    } on Error {
      _showToast(Constants.standardErrorMessage);
    }
  }

  // This function shows a success dialog when a job is accepted
  static Future<void> _showSuccessDialog(BuildContext context, String message, JobDetailsBloc bloc) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            RaisedButton.icon(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: Icon(
                Icons.close,
                color: imagePrimaryLightColor,
              ),
              color: colorSuccessMessage,
              label: Text(
                "Close!",
                style: TextStyle(
                  color: textPrimaryLightColor,
                ),
              ),
              disabledColor: disabledButtonColour,
              onPressed: () async {
                bloc.eventSink.add(JobAcceptedSuccessEvent(
                    shouldPop: false)); // Emit success event
              },
            ),
          ],
        );
      },
    ).then(
          (onValue) {
        bloc.eventSink.add(JobAcceptedSuccessEvent(shouldPop: true));
      },
      onError: (err) {
        bloc.eventSink.add(JobAcceptedFailureEvent(shouldPop: true));
      },
    );
  }

  // Function to show a Toast message
  static void _showToast(String message) {
      Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: colorErrorMessage,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static launchURL(double lat, double long) async {
    var url = Constants.BASE_MAP_URL + lat.toString() + ',' + long.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
