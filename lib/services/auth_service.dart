import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/utils/Constants.dart';
import 'package:flutter_ui_collections/utils/colors.dart';
import 'user_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  var loginUrl = Constants.urlBase + "login";

  Future<bool> login(email, password) async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS
      formData.add("email", email);
      formData.add("password", password);

      print(loginUrl);

      Dio dio = new Dio();
      response = await dio.post(loginUrl,
          data: formData,
          options: Options(
              method: 'POST',
              responseType: ResponseType.plain // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        UserDetails.userPermissions =
            (json.decode(response.data)['permissions']);
        return true;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: json.decode(e.response.data)['msg'],
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
}
