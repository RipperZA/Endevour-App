import 'package:dio/dio.dart';
import 'package:endevour/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageForgotPassword extends StatefulWidget {
  @override
  _PageForgotPasswordState createState() => _PageForgotPasswordState();
}

class _PageForgotPasswordState extends State<PageForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  bool isLoading = false;
  var _isEmailValid = false;
  FocusNode _emailFocusNode = new FocusNode();
  TextEditingController emailController = new TextEditingController();

  Screen size;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(validEmail);
  }


  validEmail() {
    String value = emailController.text;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      setState(() {
        _isEmailValid = false;
      });
    } else {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  Future<bool> resetPassword() async {
    try {
      Response response;
      FormData formData = new FormData(); // just like JS

      formData.add("email", emailController.text.toString());

      Dio dio = new Dio();
      dio.options.connectTimeout = 10000; //5s
      response = await dio.post(Constants.urlResetPassword,
          data: formData,
          options: Options(
              method: 'POST',
              responseType: ResponseType.json // or ResponseType.JSON
          ));

      print(response.data);

      if (response.statusCode == 200)
      {
        Fluttertoast.showToast(
            msg: response.data['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorSuccessMessage,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      }

      return false;
    } on DioError catch (e) {
      print(e.response);

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
    } on Error catch (e) {
      print(1);
      print(e);

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

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        top: true,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0.0,
              primary: false,
              centerTitle: true,
             backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: colorCurve,
                ),
                onPressed: () => Navigator.pop(context, false),
              )
          ),
            backgroundColor: backgroundColor,

            body: Stack(children: <Widget>[
              ClipPath(
                  clipper: BottomShapeClipper(),
                  child: Container(
                    color: colorCurve,
                  )),
              Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _forgotGradientText(),
                  SizedBox(height: size.getWidthPx(24)),
                  Header(),
                  SizedBox(height: size.getWidthPx(24)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(16)),
                      child: _emailFeild())
                ],
              ),
                ),
              )
            ])),
      ),
    );
  }

  Header() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _passwordIconWidget(),
          SizedBox(height: size.getWidthPx(24)),
          Text(
            "Please fill your valid email address below",
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: 16.0,
                fontStyle: FontStyle.normal),
          ),
        ],
      );

  GradientText _forgotGradientText() {
    return GradientText('Forgot password',
        gradient: LinearGradient(colors: [
          Color.fromRGBO(97, 6, 165, 1.0),
          Color.fromRGBO(45, 160, 240, 1.0)
        ]),
        style: TextStyle(
            fontFamily: 'Exo2', fontSize: 30, fontWeight: FontWeight.bold));
  }

  CircleAvatar _passwordIconWidget() {
    return CircleAvatar(
      maxRadius: size.getWidthPx(82),
      child: Image.asset("assets/icons/imgforgot.png"),
      backgroundColor: colorCurve,
    );
  }

  TextFormField _emailWidget() {
    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.length > 0 && !regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

    return TextFormField(
      validator: validateEmail,
      autovalidate: true,
      textInputAction: TextInputAction.done,
      focusNode: null,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onEditingComplete: () {FocusScope.of(context).requestFocus(FocusNode());},
      obscureText: false,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  _emailFeild() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _emailWidget(),
          SizedBox(height: size.getWidthPx(20)),
          _submitButtonWidget(),
        ],
      );

  Container _submitButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(20), horizontal: size.getWidthPx(16)),
      width: size.getWidthPx(200),
      child: RaisedButton(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(size.getWidthPx(12)),
        child: Text(
          "Submit",
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
        ),
        color: colorCurve,
        onPressed: _isEmailValid ? () async {
          // Validate Email First
          var _result = await resetPassword();

          if (_result == true)
            {
              Navigator.pop(context, false);
            }


        } : null,
      ),
    );
  }

  String validateEmail(String value) {
    RegExp regExp = RegExp(Constants.PATTERN_EMAIL, caseSensitive: false);

    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid email address.";
    }
    return null;
  }

}
