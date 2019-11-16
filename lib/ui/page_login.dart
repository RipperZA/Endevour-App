import 'package:endevour/services/auth_service.dart';
import 'package:endevour/services/local_authentication_service.dart';
import 'package:endevour/services/service_locator.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_home_worker.dart';
import 'package:endevour/ui/page_onboarding.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page_home.dart';

AuthService appAuth = new AuthService();

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formEmail;
  var formPassword;
  var loginUrl = Constants.urlLogin;
  var _isEmailValid = false;
  var _isPasswordValid = false;
  bool _showSpinner = false;
  var localAuth = LocalAuthentication();
  final LocalAuthenticationService _localAuth =
      locator<LocalAuthenticationService>();

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
    OneSignal.shared.init(Constants.oneSignalAppKey);

    emailController.addListener(validEmail);
    passwordController.addListener(validPassword);

    pingOrFingerprint();
  }

  Future pingOrFingerprint() async {
    var _result = await appAuth.ping(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggingIn = await prefs.getBool(Constants.loggingIn);
    bool loggedInOnce = await prefs.getBool(Constants.loggedInOnce);

    if (_result == false && loggingIn && loggedInOnce != null && loggedInOnce) {
      this.loginFingerPrint();
    }
  }

  login() async {
    try {
      bool _result = await appAuth.login(
          this.emailController.text, this.passwordController.text);

      if (_result) {
        if (UserDetails.userRoles.contains('worker'))
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePageWorker()));
        if (UserDetails.userRoles.contains('area_manager'))
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      setState(() {
        _showSpinner = false;
      });
    } catch (e) {
      setState(() {
        _showSpinner = false;
      });
      print(e);
      return e;
    }
  }

  loginFingerPrint() async {
    try {
      await _localAuth.authenticate();

      if (_localAuth.isAuthenticated) {
        bool _result = await appAuth.loginFingerPrint();

        if (_result) {
          if (UserDetails.userRoles.contains('worker'))
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePageWorker()));
          if (UserDetails.userRoles.contains('area_manager'))
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        setState(() {
          _showSpinner = false;
        });
      }
    } catch (e) {
      setState(() {
        _showSpinner = false;
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
    if (passwordController.text.length >= 5) {
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
                    Center(
                      child: SingleChildScrollView(
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
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ]),
          inAsyncCall: _showSpinner,
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
      if (value.length > 0 && value.length < 5)
        return 'Password must be more than 4 charaters';
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
        onPressed: _isPasswordValid ? () {
          setState(() {
            _showSpinner = true;
          });
          login();
        } : null,
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
          // Going to Register Page
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
//                GestureDetector(
//                    onTap: () {
//                      //Navigate to Forgot Password Screen...
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => PageForgotPassword()));
//                    },
//                    child: Padding(
//                      padding: EdgeInsets.only(right: size.getWidthPx(24)),
//                      child: Align(
//                          alignment: Alignment.centerRight,
//                          child: Text("Forgot Password?",
//                              style: TextStyle(
//                                  fontFamily: 'Exo2', fontSize: 16.0))),
//                    )),
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
