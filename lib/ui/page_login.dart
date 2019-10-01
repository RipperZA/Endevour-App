import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/services/auth_service.dart';
import 'package:flutter_ui_collections/ui/page_onboarding.dart';
import 'package:flutter_ui_collections/ui/page_register.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';

import 'page_forgotpass.dart';
import 'page_home.dart';
import 'page_signup.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

AuthService appAuth = new AuthService();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formEmail;
  var formPassword;
  var loginUrl = Constants.urlLogin;
  var _isEmailValid = false;
  var _isPasswordValid = false;
  bool _loggingIn = false;

  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Screen size;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    emailController.addListener(validEmail);
    passwordController.addListener(validPassword);
  }

  login() async {
    try {
      bool _result = await appAuth.login(
          this.emailController.text, this.passwordController.text);

      if (_result) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      setState(() {
        _loggingIn = false;
      });
    } catch (e) {
      setState(() {
        _loggingIn = false;
      });
      print(e);
      return e;
    }
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

  validPassword() {
    if (passwordController.text.length >= 3) {
      setState(() {
        _isPasswordValid = true;
      });
    } else {
      setState(() {
        _isPasswordValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          child: Stack(children: <Widget>[
            AnnotatedRegion(
              value: SystemUiOverlayStyle(
                  statusBarColor: backgroundColor,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: backgroundColor),
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: Stack(fit: StackFit.expand, children: <Widget>[
                    ClipPath(
                        clipper: BottomShapeClipper(),
                        child: Container(
                          color: colorCurve,
                        )),
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.getWidthPx(20),
                            vertical: size.getWidthPx(20)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _loginGradientText(),
                              SizedBox(height: size.getWidthPx(10)),
                              _textAccount(),
                              SizedBox(height: size.getWidthPx(30)),
                              loginFields()
                            ]),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ]),
          inAsyncCall: _loggingIn,
        ));
  }

  RichText _textAccount() {
    return RichText(
      text: TextSpan(
          text: "Don't have an account? ",
          children: [
            TextSpan(
              style: TextStyle(color: Colors.deepOrange),
              text: 'Register Now!',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnBoardingPage())),
            )
          ],
          style: TextStyle(
              color: Colors.black87, fontSize: 14, fontFamily: 'Exo2')),
    );
  }

  GradientText _loginGradientText() {
    return GradientText('Login',
        gradient: LinearGradient(colors: [
          Color.fromRGBO(97, 6, 165, 1.0),
          Color.fromRGBO(45, 160, 240, 1.0)
        ]),
        style: TextStyle(
            fontFamily: 'Exo2', fontSize: 36, fontWeight: FontWeight.bold));
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
      textInputAction: TextInputAction.next,
      focusNode: null,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      controller: emailController,
      obscureText: false,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

//
  TextFormField _passwordWidget() {
    String validatePassword(String value) {
      if (value.length > 0 && value.length < 3)
        return 'Password must be more than 2 charaters';
      else
        return null;
    }

    return TextFormField(
      validator: validatePassword,
      autovalidate: true,
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
      controller: passwordController,
      obscureText: true,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Container _loginButtonWidget() {
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
          "LOGIN",
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
        ),
        color: colorCurve,
        onPressed: () {
          setState(() {
            _loggingIn = true;
          });
          login();
        },
      ),
    );
  }

  Container _registerButtonWidget() {
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
          "REGISTER",
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
        ),
        color: colorCurve,
        onPressed: () {
          // Going to DashBoard
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OnBoardingPage()));
        },
      ),
    );
  }

  Row _socialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        socialCircleAvatar("assets/icons/icnfb.png", () {}),
        SizedBox(width: size.getWidthPx(18)),
        socialCircleAvatar("assets/icons/icn_twitter.png", () {}),
        SizedBox(width: size.getWidthPx(18)),
        socialCircleAvatar("assets/icons/icngmail.png", () {}),
      ],
    );
  }

  GestureDetector socialCircleAvatar(String assetIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        maxRadius: size.getWidthPx(24),
        backgroundColor: Colors.transparent,
        child: Image.asset(assetIcon),
      ),
    );
  }

  loginFields() => Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _emailWidget(),
                SizedBox(height: size.getWidthPx(8)),
                _passwordWidget(),
                GestureDetector(
                    onTap: () {
                      //Navigate to Forgot Password Screen...
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageForgotPassword()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: size.getWidthPx(24)),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot Password?",
                              style: TextStyle(
                                  fontFamily: 'Exo2', fontSize: 16.0))),
                    )),
                SizedBox(height: size.getWidthPx(8)),
                _loginButtonWidget(),
                Text(
                  "OR",
                  style: TextStyle(
                      fontFamily: 'Exo2', fontSize: 16.0, color: Colors.grey),
                ),
                _registerButtonWidget(),
                SizedBox(height: size.getWidthPx(28)),

                SizedBox(height: size.getWidthPx(12)),
//                _socialButtons()
              ],
            )),
      );
}
