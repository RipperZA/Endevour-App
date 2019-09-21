import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter_ui_collections/utils/utils.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_string/random_string.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/ui/page_register.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';

import 'page_forgotpass.dart';
import 'page_home.dart';
import 'page_signup.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  var _phases = {'phaseOne': true, 'phaseTwo': false, 'phaseThree': false};
  var formName;
  var formSurname;
  var formEmail;
  var formPhoneNumber;
  var _isNameValid = false;
  var _isSurnameValid = false;
  var _isEmailValid = false;
  var _isPhoneNumberValid = false;
  var uploadUrl = Constants.urlApplicationUpload;
  AnimationController _animationController;

  static const String africanCorporateCleaningUrl =
      'https://www.africancorporatecleaning.co.za/contact.html';
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _surnameFocusNode = new FocusNode();
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _phoneNumberFocusNode = new FocusNode();

  TextEditingController nameController = new TextEditingController();
  TextEditingController surnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Exo2', fontSize: 18.0);
  List<File> _cvImages = [];
  File _selfieImage;
  File _idDocumentImage;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500),
        lowerBound: 0.3,
        upperBound: 1);
    _animationController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => _buildAboutDialog(context));
    });
    nameController.addListener(validName);
    surnameController.addListener(validSurname);
    emailController.addListener(validEmail);
    phoneNumberController.addListener(validPhoneNumber);
  }

  validName() {
    if (nameController.text.length >= 3) {
      setState(() {
        _isNameValid = true;
      });
    } else {
      setState(() {
        _isNameValid = false;
      });
    }
  }

  validSurname() {
    if (surnameController.text.length >= 3) {
      setState(() {
        _isSurnameValid = true;
      });
    } else {
      setState(() {
        _isSurnameValid = false;
      });
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

  validPhoneNumber() {
    if (phoneNumberController.text.length == 10) {
      setState(() {
        _isPhoneNumberValid = true;
      });
    } else {
      setState(() {
        _isPhoneNumberValid = false;
      });
    }
  }

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

//  Future showDialogPhaseTwo() async {
//    showDialog(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Succeaaaaaaaaaaass!"),
//          content: new Text('aaaa'),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('How To Get Started'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
//            await showDialogPhaseTwo().then((onValue) {
//              Navigator.pop(context);
//            }, onError: (err) {
//              Navigator.pop(context);
//            });
            },
            textColor: Theme.of(context).primaryColor,
            child: RaisedButton(
                textColor: Colors.white,
                color: themeColour,
                child: Text(
                  'Okay! Go To Step #1',
                  style: TextStyle(fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ],
      ),
      actions: <Widget>[],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Thank you for showing an interest! In 3 easy steps you\'ll be registered.\n\n'
            '1) Complete Personal Details and take a selfie.\n\n'
            '2) Upload your Smart ID or ID Document.\n\n'
            '3) Upload your CV.\n\n',
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Future getImageSelfie(ImageSource imgSource) async {
    var picture =
        await ImagePicker.pickImage(source: imgSource, maxHeight: 1500);
    print(picture);

    setState(() {
      if (picture != null) {
        _selfieImage = picture;
      }
    });
  }

  Future getImageIdDocument(ImageSource imgSource) async {
    var picture =
        await ImagePicker.pickImage(source: imgSource, maxHeight: 1500);
    print(picture);

    setState(() {
      if (picture != null) {
        _idDocumentImage = picture;
      }
    });
  }

  Future getImageCV(ImageSource imgSource) async {
    File picture =
        await ImagePicker.pickImage(source: imgSource, maxHeight: 1500);
    setState(() {
      if (picture != null) {
        if (_cvImages.length < 4) {
          _cvImages.add(picture);
//          _cvImages = _cvImages.reversed.toList();
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Error!"),
                content: new Text(
                    'Only A Maxiumum of 4 photos can be uploaded for your CV'),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  uploadDocuments(BuildContext context) async {
    try {
      if (_selfieImage != null && //
          _idDocumentImage != null &&
          _cvImages.length > 0) {
        var batch = randomAlphaNumeric(15);
        Response response;
        FormData formData = new FormData(); // just like JS
        formData.add("batch", batch);
        formData.add("name", formName); //rtesti
        formData.add("surname", formSurname);
        formData.add("email", formEmail);
        formData.add("cell_number", formPhoneNumber);

        formData.add("selfie_image",
            new UploadFileInfo(_selfieImage, Path.basename(_selfieImage.path)));

        formData.add(
            "id_document_image",
            new UploadFileInfo(
                _idDocumentImage, Path.basename(_idDocumentImage.path)));

        for (var i = 0; i < _cvImages.length; i++) {
          formData.add(
              "cv_image_" + i.toString(),
              new UploadFileInfo(
                  _cvImages[i], Path.basename(_cvImages[i].path)));
        }

        Dio dio = new Dio();
        response = await dio.post(uploadUrl,
            data: formData,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ));

//        if (i == _cvImages.length - 1) {
        print(response);
        print(response.data);

        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Success!"),
              content: new Text(json.decode(response.data)['success']),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ).then((onValue) {
          Navigator.pop(context);
        }, onError: (err) {
          Navigator.pop(context);
        });
//        }

        setState(() {
//          _cvImages = [];
        });
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error!"),
            content:
                new Text(json.decode(e.response.toString())['responseMessage']),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return e;
    }
  }

  Widget scaffoldPhaseOne() {
    String validateName(String value) {
      if (value.length > 0 && value.length < 3)
        return 'Name must be more than 2 charaters';
      else
        return null;
    }

    String validateSurname(String value) {
      if (value.length > 0 && value.length < 3)
        return 'Surname must be more than 2 charaters';
      else
        return null;
    }

    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.length > 0 && !regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

    String validateMobile(String value) {
      if (value.length > 0 && value.length != 10)
        return 'Mobile Number must be of 10 digits';
      else
        return null;
    }

    final heading = DefaultTextStyle(
      style: TextStyle(fontSize: 22, color: Colors.black),
      child: Text('1) Fill In Your Details'),
    );

    final nameField = TextFormField(
      validator: validateName,
      autovalidate: true,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.text,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_surnameFocusNode),
      controller: nameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final surnameField = TextFormField(
      validator: validateSurname,
      autovalidate: true,
      textInputAction: TextInputAction.next,
      focusNode: _surnameFocusNode,
      keyboardType: TextInputType.text,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_emailFocusNode),
      controller: surnameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Surname",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = TextFormField(
      validator: validateEmail,
      autovalidate: true,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final phoneNumberField = TextFormField(
      autovalidate: true,
      validator: validateMobile,
      keyboardType: TextInputType.phone,
      focusNode: _phoneNumberFocusNode,
      controller: phoneNumberController,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(10),
        WhitelistingTextInputFormatter.digitsOnly,
        BlacklistingTextInputFormatter.singleLineFormatter,
      ],
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "10 Digit Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final selfieButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: themeColour,
      child: MaterialButton(
        disabledColor: Colors.grey,
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _isNameValid &&
                _isSurnameValid &&
                _isEmailValid &&
                _isPhoneNumberValid
            ? () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                        title: new Text(
                            "Step #1 nearly done! \n\nLet\'s get your photo taken! Head and shoulders only please! Use your camera or gallery."),
                        actions: [
                          Center(
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Row(
                                    children: <Widget>[
                                      RaisedButton.icon(
                                        icon: Icon(Icons.camera_alt),
                                        textColor: Colors.white,
                                        label: Text("Camera"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          getImageSelfie(ImageSource.camera);
                                        },
                                      ),
                                      SizedBox(width: 30),
                                      new RaisedButton.icon(
                                        icon: Icon(Icons.photo_album),
                                        textColor: Colors.white,
                                        label: new Text("Gallery"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          getImageSelfie(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    children: <Widget>[
                                      new RaisedButton.icon(
                                        icon: Icon(Icons.cancel),
                                        textColor: Colors.white,
                                        color: Colors.red,
                                        label: new Text("Cancel"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]);
                  },
                );
              }
            : null,
        child: Text("Take Selfie",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: AnnotatedRegion(
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
                      child: Center(
                        child: Container(
//            color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 0.0),
                                  heading,
                                  SizedBox(height: 10.0),
                                  nameField,
                                  SizedBox(height: 10.0),
                                  surnameField,
                                  SizedBox(height: 10.0),
                                  emailField,
                                  SizedBox(height: 10.0),
                                  phoneNumberField,
                                  SizedBox(height: 10.0),
                                  selfieButton,
                                  SizedBox(height: 15.0),
                                  Center(
                                    child: _selfieImage != null
                                        ? SizedBox(
                                            height: 350.0,
                                            child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              60, 0, 0, 0),
                                                          blurRadius: 2.0,
                                                          offset:
                                                              Offset(0.0, 0.0))
                                                    ],
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            _selfieImage)))),
                                          )
                                        : Text(
                                            'Fill In details to take Selfie'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])))),
      floatingActionButton: Center(
        child: _selfieImage != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  FadeTransition(
                    opacity: _animationController,
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () {
                        setState(() {
                          _phases['phaseOne'] = false;
                          _phases['phaseTwo'] = true;
                          _phases['phaseThree'] = false;

                          formName = nameController.text;
                          formSurname = surnameController.text;
                          formEmail = emailController.text;
                          formPhoneNumber = phoneNumberController.text;
                        });
                      },
                      //getImage,
                      tooltip: 'Proceed to next step',
                      icon: Icon(Icons.arrow_forward),
                      label: Text('Step #2'),
                    ),
                  ),
                ],
              )
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget scaffoldPhaseTwo() {
    final heading = DefaultTextStyle(
      style: TextStyle(fontSize: 26, color: Colors.black),
      child: Text('2) Upload ID Book/Smart ID'),
    );

    final idBookButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: themeColour,
      child: MaterialButton(
        disabledColor: Colors.grey,
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(
                    "Step #2 nearly done! \n\nLet\'s get your ID uploaded! Use your camera or gallery to select your ID."),
                actions: [
                  Center(
                      child: Column(children: <Widget>[
                    Center(
                      child: Row(
                        children: <Widget>[
                          RaisedButton.icon(
                            icon: Icon(Icons.camera_alt),
                            textColor: Colors.white,
                            label: Text("Camera"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImageIdDocument(ImageSource.camera);
                            },
                          ),
                          SizedBox(width: 30),
                          new RaisedButton.icon(
                            icon: Icon(Icons.photo_album),
                            textColor: Colors.white,
                            label: new Text("Gallery"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImageIdDocument(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          new RaisedButton.icon(
                            icon: Icon(Icons.cancel),
                            textColor: Colors.white,
                            color: Colors.red,
                            label: new Text("Cancel"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    )
                  ]))
                ],
              );
            },
          );
        },
        child: Text("Upload ID",
            textAlign: TextAlign.center,
            style: style.copyWith(
                backgroundColor: themeColour,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
//            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    heading,
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    idBookButton,
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: _idDocumentImage != null
                          ? SizedBox(
                              height: 350.0,
                              child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(60, 0, 0, 0),
                                            blurRadius: 2.0,
                                            offset: Offset(0.0, 0.0))
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(_idDocumentImage)))),
                            )
                          : Text(''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Center(
        child: _idDocumentImage != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  FadeTransition(
                    opacity: _animationController,
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () {
                        setState(() {
                          _phases['phaseOne'] = false;
                          _phases['phaseTwo'] = false;
                          _phases['phaseThree'] = true;
                          print(_selfieImage);
                          print(_idDocumentImage);
                          print(_phases);
                        });
                      },
                      //getImage,
                      tooltip: 'Proceed to next step',
                      icon: Icon(Icons.arrow_forward),
                      label: Text('Step #3'),
                    ),
                  ),
                ],
              )
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget scaffoldPhaseThree() {
    final heading = DefaultTextStyle(
      style: TextStyle(fontSize: 26, color: Colors.black),
      child: Text('3) Please Upload Your CV. Max of 4 photos'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
//            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    heading,
                    SizedBox(height: 15.0),
                    Center(
                      child: _cvImages.length > 0
                          ? SizedBox(
                              height: 350.0,
                              child: Carousel(
                                  boxFit: BoxFit.cover,
                                  borderRadius: true,
                                  autoplay: false,
                                  dotColor: Colors.black,
                                  animationCurve: Curves.linear,
                                  dotSize: 6.0,
                                  dotIncreasedColor: Colors.blue,
                                  dotBgColor: Colors.transparent,
                                  dotVerticalPadding: 10.0,
                                  dotPosition: DotPosition.bottomCenter,
                                  showIndicator: true,
                                  indicatorBgPadding: 7.0,
                                  images: _cvImages.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Image.file(i));
                                      },
                                    );
                                  }).toList()),
                            )
                          : Text(''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          _cvImages.length < 4
              ? FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text(
                              "Registration Nearly done! \n\nLet\'s get your CV Uploaded! Max of 4 photos"),
                          actions: [
                            Center(
                                child: Column(children: <Widget>[
                              Center(
                                child: Row(
                                  children: <Widget>[
                                    RaisedButton.icon(
                                      icon: Icon(Icons.camera_alt),
                                      textColor: Colors.white,
                                      label: Text("Camera"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        getImageCV(ImageSource.camera);
                                      },
                                    ),
                                    SizedBox(width: 30),
                                    new RaisedButton.icon(
                                      icon: Icon(Icons.photo_album),
                                      textColor: Colors.white,
                                      label: new Text("Gallery"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        getImageCV(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  children: <Widget>[
                                    new RaisedButton.icon(
                                      icon: Icon(Icons.cancel),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      label: new Text("Cancel"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              )
                            ]))
                          ],
                        );
                      },
                    );
                  },
                  //getImage,
                  tooltip: 'Pick Image',
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Image'),
                  backgroundColor: themeColour,
                )
              : Text(''),
          _cvImages.length > 0
              ? SizedBox(
                  width: 10,
                )
              : Text(''),
          _cvImages.length > 0
              ? FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("Please Confirm Upload"),
                          content: new Text(
                              'Are you sure you would like to upload your Application?'),
                          actions: <Widget>[
                            Column(
                              crossAxisAlignment:
                                  prefix1.CrossAxisAlignment.end,
//                              mainAxisAlignment: prefix1.MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    RaisedButton.icon(
                                      icon: Icon(Icons.cancel),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      label: Text("No! Make Changes"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    new RaisedButton.icon(
                                      icon: Icon(Icons.file_upload),
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      label:
                                          new Text("Yes! Upload Application"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        uploadDocuments(this.context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            )
                            // usually buttons at the bottom of the dialog
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Upload CV',
                  icon: Icon(Icons.file_upload),
                  label: Text('Upload'),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                )
              : Text(''),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget scaffoldToShow() {
    if (_phases['phaseOne'] == true) {
      return scaffoldPhaseOne();
    } else if (_phases['phaseTwo'] == true) {
      return scaffoldPhaseTwo();
    } else if (_phases['phaseThree'] == true) {
      return scaffoldPhaseThree();
    } else {
      return scaffoldPhaseOne();
    }
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldToShow();
  }
}
