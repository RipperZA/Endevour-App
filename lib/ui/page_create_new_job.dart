import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/model/Site.dart';
import 'package:flutter_ui_collections/model/models.dart';
import 'package:flutter_ui_collections/services/user_service.dart';
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

class CreateNewJobPage extends StatefulWidget {
  @override
  _CreateNewJobPageState createState() => _CreateNewJobPageState();
}

class _CreateNewJobPageState extends State<CreateNewJobPage> {
  Screen size;
  int _selectedIndex = 1;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  static TextStyle style = TextStyle(fontFamily: 'Exo2', fontSize: 18.0);
  static UnderlineInputBorder _underlineInputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black));

//  final _formKey = GlobalKey<FormState>();

  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _clientSite = (val) {
    print(val);
    print(44444);
  };

  ValueChanged _onChanged = (val) {
    print(2222);
  };

  List<Property> premiumList = List();
  List<Property> featuredList = List();
  List<Site> siteList = List();
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
          setState(() {
            this.siteList.add(site);
          });
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

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getSites();
    premiumList
      ..add(Property(
          propertyName: "Omkar Lotus",
          propertyLocation: "Ahmedabad ",
          image: "feature_1.jpg",
          propertyPrice: "26.5 Cr"))
      ..add(Property(
          propertyName: "Sandesh Heights",
          propertyLocation: "Baroda ",
          image: "feature_2.jpg",
          propertyPrice: "11.5 Cr"))
      ..add(Property(
          propertyName: "Sangath Heights",
          propertyLocation: "Pune ",
          image: "feature_3.jpg",
          propertyPrice: "19.0 Cr"))
      ..add(Property(
          propertyName: "Adani HighRise",
          propertyLocation: "Mumbai ",
          image: "hall_1.jpg",
          propertyPrice: "22.5 Cr"))
      ..add(Property(
          propertyName: "N.G Tower",
          propertyLocation: "Gandhinagar ",
          image: "hall_2.jpeg",
          propertyPrice: "7.5 Cr"))
      ..add(Property(
          propertyName: "Vishwas CityRise",
          propertyLocation: "Pune ",
          image: "hall_1.jpg",
          propertyPrice: "17.5 Cr"))
      ..add(Property(
          propertyName: "Gift City",
          propertyLocation: "Ahmedabad ",
          image: "hall_2.jpeg",
          propertyPrice: "13.5 Cr"))
      ..add(Property(
          propertyName: "Velone City",
          propertyLocation: "Mumbai ",
          image: "feature_1.jpg",
          propertyPrice: "11.5 Cr"))
      ..add(Property(
          propertyName: "PabelBay",
          propertyLocation: "Ahmedabad ",
          image: "hall_1.jpg",
          propertyPrice: "33.1 Cr"))
      ..add(Property(
          propertyName: "Sapath Hexa Tower",
          propertyLocation: "Ahmedabad",
          image: "feature_3.jpg",
          propertyPrice: "15.6 Cr"));
  }

  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion(
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
                  autovalidate: true,
                  initialValue: {
                    'movie_rating': 5,
                  },
                  // readOnly: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        FormBuilderTypeAhead(
                          decoration: InputDecoration(
//                            enabledBorder: _underlineInputBorder,
//                            focusedBorder: _underlineInputBorder,
//                            labelStyle: style,
                            labelText: "Client Site",
                          ),
                          attribute: 'client_site',
                          onChanged: _clientSite,
                          itemBuilder: (context, site) {
                            return ListTile(
                              title: Text(site.name),
                            );
                          },
//                          initialValue: siteList[0].name,
                          selectionToTextTransformer: (Site site) => site.name,
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
                        FormBuilderDateTimePicker(
                          attribute: "date",
                          onChanged: _onChanged,
                          inputType: InputType.time,
                          // format: DateFormat("yyyy-MM-dd hh:mm"),
                          // initialValue: DateTime.now(),
                          decoration: InputDecoration(labelText: "Start Time"),
                          // readonly: true,
                        ),
                        FormBuilderDateTimePicker(
                          attribute: "date",
                          onChanged: _onChanged,
                          inputType: InputType.time,
                          // format: DateFormat("yyyy-MM-dd hh:mm"),
                          // initialValue: DateTime.now(),
                          decoration: InputDecoration(labelText: "End Time"),
                          // readonly: true,
                        ),
                        FormBuilderDateRangePicker(
                          attribute: "date_range",
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2020),
                          format: DateFormat("yyyy-MM-dd"),
                          onChanged: _onChanged,
                          decoration: InputDecoration(labelText: "Date Range"),
                          // readonly: true,
                        ),
//                        FormBuilderCustomField(
//                          attribute: "client_site_select_only",
//                          validators: [
//                            FormBuilderValidators.required(),
//                          ],
//                          formField: FormField(
//                            // key: _fieldKey,
//                            enabled: true,
//                            builder: (FormFieldState<dynamic> field) {
//                              return InputDecorator(
//                                decoration: InputDecoration(
//                                  labelText: "Select Site",
//                                  contentPadding:
//                                      EdgeInsets.only(top: 10.0, bottom: 0.0),
//                                  border: InputBorder.none,
//                                  errorText: field.errorText,
//                                ),
//                                child: DropdownButton(
//                                  isExpanded: true,
//                                  items: siteList.map((option) {
//                                    return DropdownMenuItem(
//                                      child: Text(option.name),
//                                      value: option,
//                                    );
//                                  }).toList(),
//                                  value: field.value,
//                                  onChanged: (value) {
//                                    field.didChange(value);
//                                  },
//                                ),
//                              );
//                            },
//                          ),
//                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: size.getWidthPx(20),
                          horizontal: size.getWidthPx(16)),
                      width: size.getWidthPx(200),
                      child: RaisedButton(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(size.getWidthPx(12)),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontFamily: 'Exo2',
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                        color: colorCurve,
                        disabledColor: disabledButtonColour,
                        onPressed: () {
//              login();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            print(_fbKey.currentState.value);
                          } else {
                            print(_fbKey.currentState.value);
                            print("validation failed");
                          }
                          print(_fbKey.currentState.value['contact_person']
                              .runtimeType);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _fbKey.currentState.reset();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
                fontFamily: 'Exo2',
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
            fontFamily: 'Exo2',
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
