import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/utils/Constants.dart';
import 'package:flutter_ui_collections/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'user_service.dart';

class AuthService {
  var loginUrl = Constants.urlLogin;

  Future<bool> login(email, password) async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS
//      formData.add("email", email);
//      formData.add("password", password);
      formData.add("email", 'area@gmail.com');
//      formData.add("email", 'worker@gmail.com');
//      formData.add("email", 'alexspy1@gmail.com');
      formData.add("password", 'qwerty');
//      formData.add("password", 'secret');

      print(loginUrl);

      Dio dio = new Dio();
      response = await dio.post(loginUrl,
          data: formData,
          options: Options(
              method: 'POST',
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        UserDetails.userPermissions = response.data['permissions'];
        UserDetails.userRoles = response.data['roles'];
        UserDetails.token = response.data['token'];
        UserDetails.name = response.data['name'];
        UserDetails.surname = response.data['surname'];
        UserDetails.verified = response.data['verified'];

        this.updateUserPushIdAndToken();

        return true;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
//     await showDialog(
//          context: context,
//          builder: (_) => new AlertDialog(
//                title: new Text("Error!"),
//                content: new Text(json.decode(e.response.data)['msg']),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Close"),
//                    onPressed: ()  {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                ],
//              ));

      return false;
    }
  }

  Future<bool> updateUserPushIdAndToken() async {
    try {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      var playerId = status.subscriptionStatus.userId;
      var playerToken = status.subscriptionStatus.pushToken;

      print(playerId);
      print(playerToken);

      Response response;
      FormData formData = new FormData(); // just like JS
      formData.add("push_id", playerId);
      formData.add("push_token", playerToken);

      Dio dio = new Dio();
      response = await dio.post(Constants.urlPushIdAndToken,
          data: formData,
          options: Options(
              method: 'POST',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        print(response.data);
        return true;
      }

      return false;
    } on DioError catch (e) {
      print(e.response.data['msg']);
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
  }

  Future<bool> updatePassword(password) async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS
      formData.add("password", password.toString());

      Dio dio = new Dio();
      response = await dio.post(Constants.urlUpdatePassword,
          data: formData,
          options: Options(
              method: 'POST',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: response.data['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorSuccessMessage,
            textColor: Colors.white,
            fontSize: 16.0);
        UserDetails.verified = response.data['verified'];
        return true;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
  }
}
