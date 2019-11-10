import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/ui/page_home.dart';
import 'package:flutter_ui_collections/ui/page_home_worker.dart';
import 'package:flutter_ui_collections/utils/Constants.dart';
import 'package:flutter_ui_collections/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
//      formData.add("password", 'qwerty');
      formData.add("password", 'Secret');

      Dio dio = new Dio();
      response = await dio.post(loginUrl,
          data: formData,
          options: Options(
              method: 'POST',
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        UserDetails.userPermissions =
            response.data['permissions'].cast<String>();
        UserDetails.userRoles = response.data['roles'].cast<String>();
        ;
        UserDetails.token = response.data['token'];
        UserDetails.name = response.data['name'];
        UserDetails.surname = response.data['surname'];
        UserDetails.verified = response.data['verified'];

        await setItemsInStorage();

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

  Future<void> setItemsInStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
        Constants.storageUserPermissions, UserDetails.userPermissions);
    await prefs.setStringList(
        Constants.storageUserRoles, UserDetails.userRoles);
    await prefs.setString(Constants.storageUserToken, UserDetails.token);
    await prefs.setString(Constants.storageUserName, UserDetails.name);
    await prefs.setString(Constants.storageUserSurname, UserDetails.surname);
    await prefs.setBool(Constants.storageUserVerified, UserDetails.verified);
  }

  Future<void> getItemsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserDetails.userPermissions =
        prefs.getStringList(Constants.storageUserPermissions);
    UserDetails.userRoles = prefs.getStringList(Constants.storageUserRoles);
    UserDetails.token = prefs.getString(Constants.storageUserToken);
    UserDetails.name = prefs.getString(Constants.storageUserName);
    UserDetails.surname = prefs.getString(Constants.storageUserSurname);
    UserDetails.verified = prefs.getBool(Constants.storageUserVerified);
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

  Future<bool> ping(context) async {
    try {
      Response response;

      await this.getItemsFromStorage();

      if (UserDetails.token != null) {
        Dio dio = new Dio();
        response = await dio.get(Constants.urlPing,
            options: Options(
                method: 'GET',
                headers: {'Authorization': 'Bearer ' + UserDetails.token},
                responseType: ResponseType.json // or ResponseType.JSON
                ));

        try {
          if (response.data['ping'] == true) {
            Fluttertoast.showToast(
                msg: response.data['msg'],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIos: 1,
                backgroundColor: colorSuccessMessage,
                textColor: Colors.white,
                fontSize: 16.0);

            if (UserDetails.userRoles.contains('worker'))
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePageWorker()));
            if (UserDetails.userRoles.contains('area_manager'))
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));

            return true;
          }

          return false;
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Session Expired. Please Login Again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: colorErrorMessage,
              textColor: Colors.white,
              fontSize: 16.0);
          return false;
        }
      }
      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Session Expired. Please Login Again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
  }

  Future<bool> logout() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlLogout,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        await Fluttertoast.showToast(
            msg: response.data['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorSuccessMessage,
            textColor: Colors.white,
            fontSize: 16.0);

        UserDetails.userPermissions = [];
        UserDetails.userRoles = [];
        UserDetails.token = '';
        UserDetails.name = '';
        UserDetails.surname = '';
        UserDetails.verified = false;

        await setItemsInStorage();
        print(33);

//        return true;
      }

      return false;
    } on DioError catch (e) {
      try {
        Fluttertoast.showToast(
            msg: e.response.data['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorErrorMessage,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } catch (e) {
        Fluttertoast.showToast(
            msg: Constants.standardErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorErrorMessage,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
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
      return false;
    }
  }
}
