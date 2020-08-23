import 'dart:async';

import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:dio/dio.dart';
import 'package:endevour/model/Rate.dart';
import 'package:endevour/model/Site.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_home.dart';
import 'package:endevour/utils/utils.dart';
import 'package:endevour/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'CustomDayTileBuilder.dart';

class CreateNewJobPage extends StatefulWidget {
  @override
  _CreateNewJobPageState createState() => _CreateNewJobPageState();
}

class _CreateNewJobPageState extends State<CreateNewJobPage> {
  Screen size;
  int _selectedIndex = 1;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(-25.8197299, 28.290334);
  Site currentSite = new Site();
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool showSiteOnMaps = false;
  bool _saving = false;
  var uploadUrl = Constants.urlNewJobUpload;
  String calendarMonthName =
      DateFormat('yyyy-MMMM').format(DateTime.now()).toString();
  var workDates = [];
  var startTime;
  var endTime;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Set<Marker> _markers = {
    Marker(
        markerId: MarkerId("African Corporate Cleaning"),
        position: LatLng(-25.8197299, 28.290334),
        infoWindow: InfoWindow(
          title: "African Corporate Cleaning",
        ))
  };
  TextStyle style = TextStyle(fontSize: 21.0);
  static UnderlineInputBorder _underlineInputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black));

  List<Site> siteList = List();
  List<Rate> rateList = List();

  TimeOfDay _startTimeInitial = new TimeOfDay(hour: 07, minute: 00);
  TimeOfDay _endTimeInitial = new TimeOfDay(hour: 16, minute: 30);

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _startTimeInitial,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        _startTimeInitial = picked;
        if (picked.minute < 10) {
          startTime =
              picked.hour.toString() + ":" + "0" + picked.minute.toString();
        } else {
          startTime = picked.hour.toString() + ":" + picked.minute.toString();
        }
      });
    } else {
      setState(() {
        _startTimeInitial = _startTimeInitial;
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _endTimeInitial,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        _endTimeInitial = picked;
        if (picked.minute < 10) {
          endTime =
              picked.hour.toString() + ":" + "0" + picked.minute.toString();
        } else {
          endTime = picked.hour.toString() + ":" + picked.minute.toString();
        }
      });
    } else {
      setState(() {
        _endTimeInitial = _endTimeInitial;
      });
    }
  }

  getSites() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetAreaManagerSites,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        var sites = response.data['data']['sites'];

        for (var x in sites) {
          var site = Site.fromJson(x);

          if (this.mounted) {
            setState(() {
              this.siteList.add(site);
            });
          }
        }
      }

      return false;
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
      try {
        Fluttertoast.showToast(
            msg: e.response.data['error'],
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
    }
  }

  getRates() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetRates,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        var rates = response.data['data']['rates'];

        for (var x in rates) {
          var rate = Rate.fromJson(x);

          if (this.mounted) {
            setState(() {
              this.rateList.add(rate);
            });
          }
        }
      }

      return false;
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
      try {
        Fluttertoast.showToast(
            msg: e.response.data['error'],
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
    }
  }

  final double _zoom = 16;

  Future<void> _goToNewSite() async {
    double lat = currentSite.latitude;
    double long = currentSite.longitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));

    setState(() {
      _markers.clear();

      _markers.add(Marker(
          markerId: MarkerId(currentSite.name),
          position: LatLng(currentSite.latitude, currentSite.longitude),
          infoWindow: InfoWindow(
            title: currentSite.name,
          )));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getSites();
    this.getRates();
  }

  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    determineColour(rateCode) {
      if (rateCode.toString().toLowerCase().contains('public_holiday'))
        return publicHolidayColour;
      else if (rateCode.toString().toLowerCase().contains('saturday'))
        return saturdayColour;
      else if (rateCode.toString().toLowerCase().contains('sunday'))
        return sundayColour;
      else
        return standardColour;
    }

    uploadNewJob(BuildContext context) async {
      {
        try {
          _saving = true;

          Response response;
          var formValues = _fbKey.currentState.value;
          FormData formData = new FormData.fromMap(<String, dynamic>{
            "client_site": currentSite.uuid,
            'number_workers': formValues['number_workers'],
            'start_time': startTime,
            'end_time': endTime,
            'dates': workDates,
            'lunch_duration': formValues['lunch_duration'],
          });

          Dio dio = new Dio();
          response = await dio.post(uploadUrl,
              data: formData,
              options: Options(
                  method: 'POST',
                  headers: {
                    'Authorization': 'Bearer ' + UserDetails.token,
                    'Accept': 'application/json'
                    //NB Important to retrieve validation errors from Server
                  },
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));

          await Fluttertoast.showToast(
              msg: response.data['success'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: colorSuccessMessage,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            _saving = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        } on DioError catch (e) {
          setState(() {
            _saving = false;
          });
          try {
            Fluttertoast.showToast(
                msg: e.response.data['error'] ?? e.response.data['message'],
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
        }
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        child: Stack(children: <Widget>[
          AnnotatedRegion(
            value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: backgroundColor),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    upperPart(),
                    FormBuilder(
                      key: _fbKey,
                      autovalidate: false,
                      initialValue: {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Select Client Site',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    FormBuilderTypeAhead(
                                      initialValue: new Site(),
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                      decoration: InputDecoration(
                                        labelText:
                                            "Client Site (Search by Site Name)",
                                      ),
                                      attribute: 'client_site',
                                      onChanged: (site) => {
                                        setState(() {
                                          currentSite = site;
                                          _center = LatLng(currentSite.latitude,
                                              currentSite.longitude);
                                          _goToNewSite();
                                        })
                                      },
                                      itemBuilder: (context, site) {
                                        return ListTile(
                                          title: Text(site.name),
                                        );
                                      },
                                      selectionToTextTransformer: (Site site) =>
                                          site.name,
                                      suggestionsCallback: (query) {
                                        if (query.length != 0) {
                                          var lowercaseQuery =
                                              query.toLowerCase();
                                          return siteList.where((site) {
                                            return site.name
                                                .toLowerCase()
                                                .contains(lowercaseQuery);
                                          }).toList(growable: false)
                                            ..sort((a, b) => a.name
                                                .toLowerCase()
                                                .indexOf(lowercaseQuery)
                                                .compareTo(b.name
                                                    .toLowerCase()
                                                    .indexOf(lowercaseQuery)));
                                        } else {
                                          return siteList;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Select # Of Workers',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    FormBuilderStepper(
                                      decoration: InputDecoration(
                                        labelStyle: style,
                                        labelText: "No. Of Workers",
                                      ),
                                      attribute: "number_workers",
                                      initialValue: 1,
                                      min: 1,
                                      max: 10,
                                      step: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: size.wp(100),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Select Work Hours',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Start - ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          new GestureDetector(
                                            onTap: () async {
                                              _selectStartTime(context);
                                            },
                                            child: startTime != null
                                                ? Text(
                                                    startTime,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: themeColour),
                                                  )
                                                : Text("Set Start Time",
                                                    style: TextStyle(
                                                        color: themeColour,
                                                        fontSize: 18)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {},
                                            child: Text(
                                              "End - ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          new GestureDetector(
                                            onTap: () async {
                                              _selectEndTime(context);
                                            },
                                            child: endTime != null
                                                ? Text(
                                                    endTime,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: themeColour),
                                                  )
                                                : Text(
                                                    "Set End Time",
                                                    style: TextStyle(
                                                        color: themeColour,
                                                        fontSize: 18),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Enter Lunch Duration',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    FormBuilderStepper(
                                      decoration: InputDecoration(
                                        labelStyle: style,
                                        labelText:
                                            "Lunch Duration (in minutes)",
                                      ),
                                      attribute: "lunch_duration",
                                      initialValue: 0,
                                      min: 0,
                                      max: 120,
                                      step: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Rates Legend",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 10, bottom: 0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: rateList.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                        width: 16.0,
                                                        height: 16.0,
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                              color: determineColour(
                                                                  rateList[
                                                                          index]
                                                                      .code)),
                                                        )),
                                                    Text(
                                                        ' ${rateList[index].name}: R ${rateList[index].ratePerHour.toStringAsFixed(2)}'),
                                                  ],
                                                )
                                              ]);
                                        }),
                                    ListView(
                                        padding:
                                            EdgeInsets.only(top: 0, bottom: 0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 16.0,
                                                  height: 16.0,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color: themeColour),
                                                  )),
                                              Text(' Selected Date'),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 16.0,
                                                  height: 16.0,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            colorLightYellow),
                                                  )),
                                              Text(' Today'),
                                            ],
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Dates For Work",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      calendarMonthName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 260,
                                      child: Calendarro(
                                        startDate: DateTime(DateTime.now().year,
                                            DateTime.now().month, 01),
                                        endDate: DateTime(DateTime.now().year,
                                            DateTime.now().month + 3, 0),
                                        onPageSelected:
                                            (pageStartDate, pageEndDate) {
                                          setState(() {
                                            calendarMonthName =
                                                DateFormat('yyyy-MMMM')
                                                    .format(pageStartDate)
                                                    .toString();
                                          });
                                        },
                                        weekdayLabelsRow:
                                            CalendarroWeekdayLabelsView(),
                                        dayTileBuilder: CustomDayTileBuilder(
                                            todayHighlightColor:
                                                colorLightYellow),
                                        displayMode: DisplayMode.MONTHS,
                                        selectionMode: SelectionMode.MULTI,
//                                      onTap: (date) =>
                                        onTap: (date) {
                                          setState(() {
                                            workDates.indexOf(date) != -1
                                                ? workDates.remove(date)
                                                : workDates.add(date);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton.icon(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          icon: Icon(
                            Icons.map,
                            color: imagePrimaryLightColor,
                          ),
                          color: themeColour,
                          label: new Text(
                            "Verify Site On Maps",
                            style: TextStyle(
//                              fontFamily: 'Exo2',
                              color: textPrimaryLightColor,
                            ),
                          ),
                          disabledColor: disabledButtonColour,
                          onPressed: () {
                            setState(() {
                              showSiteOnMaps = !showSiteOnMaps;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton.icon(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          label: new Text(
                            "Submit",
                            style: TextStyle(
                              color: textPrimaryLightColor,
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: imagePrimaryLightColor,
                          ),
                          color: themeColour,
                          disabledColor: disabledButtonColour,
                          onPressed: _fbKey.currentState != null &&
                                  workDates.length > 0
                              ? () {
                                  print(_fbKey.currentState.value);

                                  if (_fbKey.currentState.saveAndValidate() &&
                                      workDates.length > 0 &&
                                      startTime != null &&
                                      endTime != null) {
                                    setState(() {
                                      _fbKey.currentState.value['client_site'] =
                                          currentSite.uuid;
                                      uploadNewJob(context);
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Validation Falied. Fill out all fields and select valid work dates and times.',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIos: 1,
                                        backgroundColor: colorErrorMessage,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    print(_fbKey.currentState.value);
                                    print("validation failed");
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: showSiteOnMaps
                          ? Container(
                              height: size.getWidthPx(400),
                              child: GoogleMap(
                                markers: _markers,
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 16.0,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
        inAsyncCall: _saving,
      ),
    );
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurveSecondary],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.only(top: size.getWidthPx(36)),
                child: Column(
                  children: <Widget>[
                    titleWidget(),
                    SizedBox(height: size.getWidthPx(10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text titleWidget() {
    return Text("Create New Job",
        style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.white));
  }
}
