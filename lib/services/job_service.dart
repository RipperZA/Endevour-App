import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/model/JobList.dart';
import 'package:endevour/services/user_service.dart';

import '../ui/page_home_worker.dart';

class JobService {
  static final String _acceptJobUrl = Constants.urlAcceptJob;

  static Future<void> acceptJob(JobList job, BuildContext context) async {
    try {
      Response response;

      Dio dio = Dio();
      response = await dio.get(
        '$_acceptJobUrl${job.batch}',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer ${UserDetails.token}'},
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        await _showSuccessDialog(context, response.data['message']);
      }
    } on DioError catch (e) {
      _handleDioError(e);
    } on Error {
      _handleError();
    }
  }

  static Future<void> _showSuccessDialog(
      BuildContext context, String message) async {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageWorker(),
                  ),
                );
              },
            ),
          ],
        );
      },
    ).then(
          (onValue) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageWorker(),
          ),
        );
      },
      onError: (err) {
        Navigator.pop(context);
      },
    );
  }

  static void _handleDioError(DioError e) {
    try {
      Fluttertoast.showToast(
        msg: e.response.data['error'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: colorErrorMessage,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: Constants.standardErrorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: colorErrorMessage,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static void _handleError() {
    Fluttertoast.showToast(
      msg: Constants.standardErrorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: colorErrorMessage,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
