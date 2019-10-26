import 'dart:async';
import 'dart:convert';

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/model/Rate.dart';
import 'package:flutter_ui_collections/model/Site.dart';
import 'package:flutter_ui_collections/model/models.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
import 'package:flutter_ui_collections/ui/page_home.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/utils/utils.dart' as prefix0;
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ui_collections/utils/data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:calendarro/calendarro.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateNewJobPage extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  CreateNewJobPage({Key key, this.changeCurrentTab}) : super(key: key);

  @override
  _CreateNewJobPageState createState() => _CreateNewJobPageState();
}

class _CreateNewJobPageState extends State<CreateNewJobPage> {
  Screen size;
  int _selectedIndex = 1;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(-25.8197299, 28.290334);
  Site _currentSite = new Site();
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

//  final _formKey = GlobalKey<FormState>();

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

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  ValueChanged _clientSite = (val) {
    print(val);
    print(44444);
  };

  ValueChanged _onChanged = (val) {
    print(2222);
  };

  List<Site> siteList = List();
  List<Rate> rateList = List();
  var citiesList = [
    "Ahmedabad",
    "Mumbai",
    "Delhi ",
    "Chennai",
    "Goa",
    "Kolkata",
    "Indore",
    "Jaipur"
  ];

  getSites() async {
    try {
      Response response;

      Dio dio = new Dio();
      response = await dio.get(Constants.urlGetAreaManagerSites,
          options: Options(
              method: 'GET',
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.plain // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        var sites = json.decode(response.data)['data']['sites'];

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
      Fluttertoast.showToast(
          msg: json.decode(e.response.data)['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
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
              responseType: ResponseType.plain // or ResponseType.JSON
              ));

      if (response.statusCode == 200) {
        var rates = json.decode(response.data)['data']['rates'];

        for (var x in rates) {
          var rate = Rate.fromJson(x);
          print(rate.ratePerHour);

          if (this.mounted) {
            setState(() {
              this.rateList.add(rate);
            });
          }
        }
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: json.decode(e.response.data)['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: colorErrorMessage,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  final double _zoom = 16;

  Future<void> _goToNewSite() async {
    double lat = _currentSite.latitude;
    double long = _currentSite.longitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));

    setState(() {
      _markers.clear();

      _markers.add(Marker(
          markerId: MarkerId(_currentSite.name),
          position: LatLng(_currentSite.latitude, _currentSite.longitude),
          infoWindow: InfoWindow(
            title: _currentSite.name,
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

//    OneSignal.shared.init("28fe38a2-d375-4d9f-9b9b-c14eafabfa02");
  }

  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    uploadNewJob(BuildContext context) async {
      {
        try {
          Response response;
          var formValues = _fbKey.currentState.value;
//          print(json.encode(formValues));

          FormData formData = new FormData(); // just like JS
          formData.addAll(formValues);
          formData.add('dates', workDates);

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

          Fluttertoast.showToast(
              msg: response.data['success'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: colorSuccessMessage,
              textColor: Colors.white,
              fontSize: 16.0);
//
//          await showDialog(
//            barrierDismissible: false,
//            context: context,
//            builder: (BuildContext context) {
//              // return object of type Dialog
//              return AlertDialog(
//                title: new Text("Success!"),
//                content: new Text(json.decode(response.data)['success']),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Close"),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    },
//                  ),
//                ],
//              );
//            },
//          ).then((onValue) {
//            Navigator.pop(context);
//          }, onError: (err) {
//            Navigator.pop(context);
//          });

          setState(() {
            _saving = false;
//            Navigator.pushReplacement(
//                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        } on DioError catch (e) {
          print((e.response));

          setState(() {
            _saving = false;
//            Navigator.pushReplacement(
//                context, MaterialPageRoute(builder: (context) => HomePage()));
          });

          Fluttertoast.showToast(
              msg: json.decode(e.response.toString())['message'],
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
                      // context,
                      key: _fbKey,
                      autovalidate: false,

                      initialValue: {},
                      // readOnly: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            FormBuilderTypeAhead(
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              decoration: InputDecoration(
//                            enabledBorder: _underlineInputBorder,
//                            focusedBorder: _underlineInputBorder,
//                            labelStyle: style,
                                labelText: "Client Site (Search by Site Name)",
                              ),
                              attribute: 'client_site',
                              onChanged: (site) => {
                                setState(() {
                                  _currentSite = site;
                                  _center =
                                      LatLng(site.latitude, site.longitude);
                                  _goToNewSite();
                                })
                              },
                              itemBuilder: (context, site) {
                                return ListTile(
                                  title: Text(site.name),
                                );
                              },
//                          initialValue: siteList[0].name,
                              selectionToTextTransformer: (Site site) =>
                                  site.name,
                              suggestionsCallback: (query) {
                                if (query.length != 0) {
                                  var lowercaseQuery = query.toLowerCase();
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
                            FormBuilderCustomField(
                              attribute: "rate",
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              formField: FormField(
                                // key: _fieldKey,
                                enabled: true,
//                              initialValue: rateList.first.uuid,
                                builder: (FormFieldState<dynamic> field) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      labelStyle: style,
                                      labelText: "Select Rate",
                                      contentPadding: EdgeInsets.only(
                                          top: 10.0, bottom: 0.0),
                                      border: InputBorder.none,
                                      errorText: field.errorText,
                                    ),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: rateList.map((option) {
                                        return DropdownMenuItem(
                                          child: Text(option.name +
                                              '- R' +
                                              option.ratePerHour.toString()),
                                          value: option.uuid,
                                        );
                                      }).toList(),
                                      value: field.value,
                                      onChanged: (value) {
                                        field.didChange(value);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            FormBuilderStepper(
                              decoration: InputDecoration(
                                labelStyle: style,
                                labelText: "No. Of Workers",
                              ),
                              attribute: "number_workers",
                              initialValue: 1,
                              max: 10,
                              step: 1,
                            ),
                            FlatButton(
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      showTitleActions: true,
//                                      minTime: DateTime(2018, 3, 5),
//                                      maxTime: DateTime(2019, 6, 7),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                  }, currentTime: DateTime.now());
                                },
                                child: Text(
                                  'show date time picker',
                                  style: TextStyle(color: Colors.blue),
                                )),
                            FormBuilderDateTimePicker(
                              attribute: "start_time",
                              onChanged: _onChanged,
                              inputType: InputType.time,
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              // format: DateFormat("yyyy-MM-dd hh:mm"),
//                               initialValue: DateTime.now(),
                              decoration:
                                  InputDecoration(labelText: "Start Time"),
                              // readonly: true,
                            ),
                            FormBuilderDateTimePicker(
                              attribute: "end_time",
                              onChanged: _onChanged,
                              inputType: InputType.time,
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              // format: DateFormat("yyyy-MM-dd hh:mm"),
                              // initialValue: DateTime.now(),
                              decoration:
                                  InputDecoration(labelText: "End Time"),
                              // readonly: true,
                            ),

                            Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  "Select Dates For Work",
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline
//                              fontFamily: 'Exo2',
                                      ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  calendarMonthName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 260,
                                  child: Calendarro(
                                    startDate: DateTime(DateTime.now().year,
                                        DateTime.now().month, 01),
                                    endDate: DateTime(DateTime.now().year,
                                        DateTime.now().month + 3, 0),
                                    selectedDate: DateTime(2019, 10, 03),
                                    onPageSelected:
                                        (pageStartDate, pageEndDate) {
                                      print(222222);
                                      setState(() {
                                        calendarMonthName =
                                            DateFormat('yyyy-MMMM')
                                                .format(pageStartDate)
                                                .toString();
                                      });
                                    },
                                    weekdayLabelsRow:
                                        CalendarroWeekdayLabelsView(),
                                    dayTileBuilder: DefaultDayTileBuilder(),
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
//                            FormBuilderDateRangePicker(
//                              attribute: "date_range",
//                              firstDate: DateTime(2019),
//                              lastDate: DateTime(2020),
//                              validators: [
//                                FormBuilderValidators.required(),
//                              ],
//                              format: DateFormat("yyyy-MM-dd"),
//                              onChanged: _onChanged,
//                              decoration:
//                                  InputDecoration(labelText: "Date Range"),
//                              // readonly: true,
//                            ),
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
//              login();
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
//                              fontFamily: 'Exo2',
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
                                      workDates.length > 0) {
                                    setState(() {
                                      _fbKey.currentState.value['client_site'] =
                                          _currentSite.uuid;
                                      print(_fbKey.currentState.value);
                                      _saving = true;
                                      uploadNewJob(context);
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Validation Falied. Fill out all fields and select valid work dates.',
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
    String dropdownValue = 'One';

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
//            Container(
//              padding: EdgeInsets.symmetric(
//                  vertical: size.getWidthPx(20),
//                  horizontal: size.getWidthPx(16)),
//              width: size.getWidthPx(200),
//              child: RaisedButton(
//                elevation: 8.0,
//                shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(30.0)),
//                padding: EdgeInsets.all(size.getWidthPx(12)),
//                child: Text(
//                  "Print Sites",
//                  style: TextStyle(
//                      fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
//                ),
//                color: colorCurve,
//                onPressed: () {
//                  print(this.siteList.map((f) {
//                    return f.name;
//                  }).toList());
//                },
//              ),
//            ),
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

  Card upperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(20), vertical: size.getWidthPx(16)),
        borderOnForeground: true,
        child: Container(
          height: size.getWidthPx(150),
          child: Column(
            children: <Widget>[
              _searchWidget(),
              leftAlignText(
                  text: "Top Cities :",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: 16.0),
              HorizontalList(
                children: <Widget>[
                  for (int i = 0; i < citiesList.length; i++)
                    buildChoiceChip(i, citiesList[i])
                ],
              ),
            ],
          ),
        ));
  }

  BoxField _searchWidget() {
    return BoxField(
        controller: TextEditingController(),
        focusNode: FocusNode(),
        hintText: "Select by city, area or locality.",
        lableText: "Search...",
        obscureText: false,
        onSaved: (String val) {},
        icon: Icons.search,
        iconColor: colorCurve);
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
//                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Card propertyCard(Property property) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        borderOnForeground: true,
        child: Container(
            height: size.getWidthPx(150),
            width: size.getWidthPx(170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                    child: Image.asset('assets/${property.image}',
                        fit: BoxFit.fill)),
                SizedBox(height: size.getWidthPx(8)),
                leftAlignText(
                    text: property.propertyName,
                    leftPadding: size.getWidthPx(8),
                    textColor: colorCurve,
                    fontSize: 14.0),
                leftAlignText(
                    text: property.propertyLocation,
                    leftPadding: size.getWidthPx(8),
                    textColor: Colors.black54,
                    fontSize: 12.0),
                SizedBox(height: size.getWidthPx(4)),
                leftAlignText(
                    text: property.propertyPrice,
                    leftPadding: size.getWidthPx(8),
                    textColor: colorCurve,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800),
              ],
            )));
  }

  Padding buildChoiceChip(index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
//            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? backgroundColor : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
