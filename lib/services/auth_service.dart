import 'dart:async';

import 'package:dio/dio.dart';
import 'package:endevour/LocalBindings.dart';
import 'package:endevour/services/service_locator.dart';
import 'package:endevour/ui/page_home.dart';
import 'package:endevour/ui/page_home_worker.dart';
import 'package:endevour/ui/page_login.dart';
import 'package:endevour/utils/Constants.dart';
import 'package:endevour/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_authentication_service.dart';
import 'user_service.dart';

class AuthService {
  var loginUrl = Constants.urlLogin;
  final LocalAuthenticationService _localAuth =
      locator<LocalAuthenticationService>();

  Future<bool> login(email, password) async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS
      formData.add("email", email);
      formData.add("password", password);

      Dio dio = new Dio();
      dio.options.connectTimeout = 10000; //5s
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
        UserDetails.token = response.data['token'];
        UserDetails.name = response.data['name'];
        UserDetails.surname = response.data['surname'];
        UserDetails.verified = response.data['verified'];

        await setItemsInStorage(true,email,password);

        this.updateUserPushIdAndToken();

        return true;
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
      return false;
    } on Error {
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

  Future<bool> loginFingerPrint() async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS

      var email = await LocalStorage.sharedInstance
          .readValue(Constants.storageEmail);
      var pass = await LocalStorage.sharedInstance
          .readValue(Constants.storagePassword);

      formData.add("email", email);
      formData.add("password", pass);

      Dio dio = new Dio();
      dio.options.connectTimeout = 10000; //5s
      response = await dio.post(loginUrl,
          data: formData,
          options: Options(
              method: 'POST',
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200)
      {
        UserDetails.userPermissions = response.data['permissions'].cast<String>();
        UserDetails.userRoles = response.data['roles'].cast<String>();
        UserDetails.token = response.data['token'];
        UserDetails.name = response.data['name'];
        UserDetails.surname = response.data['surname'];
        UserDetails.verified = response.data['verified'];

        await setItemsInStorage(true,email,pass);

        this.updateUserPushIdAndToken();

        return true;
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
      return false;
    } on Error {
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

  Future<void> setItemsInStorage(bool updateCredentials,String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
        Constants.storageUserPermissions, UserDetails.userPermissions);
    await prefs.setStringList(
        Constants.storageUserRoles, UserDetails.userRoles);
    await prefs.setString(Constants.storageUserToken, UserDetails.token);
    await prefs.setString(Constants.storageUserName, UserDetails.name);
    await prefs.setString(Constants.storageUserSurname, UserDetails.surname);
    await prefs.setBool(Constants.storageUserVerified, UserDetails.verified);
    await prefs.setBool(Constants.loggedInOnce, true);

    if(updateCredentials == true)
      {
        LocalStorage.sharedInstance.writeValue(key: Constants.storageEmail, value: email);
        LocalStorage.sharedInstance.writeValue(key: Constants.storagePassword, value: password);
      }
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

      if (response.statusCode == 200)
      {
        print(response.data);
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

  Future<bool> updatePassword(password, context) async {
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

        var email = await LocalStorage.sharedInstance.readValue(Constants.storageEmail);

        await setItemsInStorage(true,email,password);

        this.logout(context);
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
//          Fluttertoast.showToast(
//              msg: "Session Expired. Please Login Again",
//              toastLength: Toast.LENGTH_LONG,
//              gravity: ToastGravity.TOP,
//              timeInSecForIos: 1,
//              backgroundColor: colorErrorMessage,
//              textColor: Colors.white,
//              fontSize: 16.0);
        return false;
      }
          return false;
    } on DioError {
//      Fluttertoast.showToast(
//          msg: "Session Expired. Please Login Again",
//          toastLength: Toast.LENGTH_LONG,
//          gravity: ToastGravity.TOP,
//          timeInSecForIos: 1,
//          backgroundColor: colorErrorMessage,
//          textColor: Colors.white,
//          fontSize: 16.0);

      return false;
    }
  }

  Future<bool> logout(context) async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlLogout,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200)
      {
        await Fluttertoast.showToast(
            msg: response.data['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorSuccessMessage,
            textColor: Colors.white,
            fontSize: 16.0);

        UserDetails.userPermissions = [].cast<String>();
        UserDetails.userRoles = [].cast<String>();
        UserDetails.token = '';
        UserDetails.name = '';
        UserDetails.surname = '';
        UserDetails.verified = false;

        //when logging out, prevent the fingerprint pop from showing
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(Constants.loggingIn, false);

        //Fix for if they logout and then tap back button it doesn't show the previous screen again. Completely pops other underlying screens
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
        return true;
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
    } on Error {
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
