import 'package:dio/dio.dart';
import 'package:endevour/services/user_service.dart';
import 'package:endevour/ui/page_completed_job.dart';
import 'package:endevour/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Screen size;
  var _profileInfo;
  List<Data> profileInfoList = List();
  bool _showSpinner = true;

  void initState() {
//    getJobInformation();

    profileInfo();

    super.initState();
  }

  Future<void> profileInfo() async {
    try {
      Response response;

      print(Constants.urlProfile);
      print(UserDetails.token);

      Dio dio = new Dio();
//      dio.options.connectTimeout = 10000; //10s
      response = await dio.get(Constants.urlProfile,
          options: Options(
              headers: {'Authorization': 'Bearer ' + UserDetails.token},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      print(response);

      if (response.statusCode == 200) {
        setState(() {
          _showSpinner = false;
        });
        _profileInfo = response.data['data']['profile_info'];

        for (var x in _profileInfo) {
          print(x);

          var info = Data.fromJson(x);

          if (this.mounted) {
            setState(() {
              this.profileInfoList.add(info);
            });
          }
        }

//        return true;
      }

//      return false;
    } on DioError catch (e) {
      try {
        setState(() {
          _showSpinner = false;
        });
        Fluttertoast.showToast(
            msg: e.response.data['error'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: colorErrorMessage,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        setState(() {
          _showSpinner = false;
        });
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
      setState(() {
        _showSpinner = false;
      });
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

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColour,
        title: Text("Profile"),
        brightness: Brightness.light,
      ),
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        child: Stack(
          children: <Widget>[
            AnnotatedRegion(
              value: SystemUiOverlayStyle(
                  statusBarColor: backgroundColor,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: backgroundColor),
              child: Container(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      upperPart(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        inAsyncCall: _showSpinner,
      ),
    );
  }

  Widget upperPart() {
    return Stack(children: <Widget>[
//      ClipPath(
//        clipper: UpperClipper(),
//        child: Container(
//          height: size.getWidthPx(80),
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              colors: [colorCurve, colorCurve],
//            ),
//          ),
//        ),
//      ),
      Column(
        children: <Widget>[
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: backgroundColor,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  profileWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
//                      likeWidget(),
                      nameWidget(),
//                      followersWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
//          Padding(
//            padding: EdgeInsets.only(
//                top: size.getWidthPx(8),
//                left: size.getWidthPx(20),
//                right: size.getWidthPx(20)),
//            child: Container(height: size.getWidthPx(4), color: colorCurve),
//          ),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: backgroundColor,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[profileDataWidget()],
              ),
            ),
          ),
          RaisedButton(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(22.0)),
            padding: EdgeInsets.all(size.getWidthPx(10)),
            child: Text(
              'View Job History',
              style: TextStyle(
                  fontFamily: 'Exo2', color: Colors.white, fontSize: 14.0),
            ),
            color: colorCurve,
            onPressed: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CompletedJobPage(
                          )));
            },
          )
        ],
      )
    ]);
  }

  Padding profileDataWidget() {
    Widget projectWidget() {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: profileInfoList.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 30,
          );
        },
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: Text(profileInfoList[index].keyName + ":",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textSecondary54,
                          fontWeight: FontWeight.w800))),
              Container(
                  child: Text(profileInfoList[index].value,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: textSecondary54,
                          fontWeight: FontWeight.w500))),
//                      likeWidget(),
//                      followersWidget(),
            ],
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            profileInfoList.length >= 1
                ? projectWidget()
                : Text('Fetching Information')
          ],
        ),
      ),
    );
  }

  Row jobInformationRow(jobLabel, jobProperty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Column(
            children: <Widget>[
              Text(jobLabel + ': ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimaryColor)),
              Text(jobProperty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textPrimaryColor))
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector followerAvatarWidget(String assetIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        maxRadius: size.getWidthPx(24),
        backgroundColor: Colors.transparent,
        child: Image.asset(assetIcon),
      ),
    );
  }

  Container buttonWidget(text) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(22.0)),
        padding: EdgeInsets.all(size.getWidthPx(2)),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 14.0),
        ),
        color: colorCurve,
        onPressed: () {},
      ),
    );
  }

  Align profileWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: size.getWidthPx(10)),
        child: CircleAvatar(
          foregroundColor: backgroundColor,
          maxRadius: size.getWidthPx(50),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            maxRadius: size.getWidthPx(48),
            foregroundColor: colorCurve,
            child: Image.asset("assets/icons/icn_coming_soon.png"),
//            backgroundImage: NetworkImage(
//                'https://avatars3.githubusercontent.com/u/17440971?s=400&u=b0d8df93a2e45812e577358cd66849e9d7cf0f90&v=4'),
          ),
        ),
      ),
    );
  }

  Column likeWidget() {
    return Column(
      children: <Widget>[
        Text("102.5k",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("Likes",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Column nameWidget() {
    return Column(
      children: <Widget>[
        Text("Alex Spyridis",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: colorCurve,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
//        Text("Photographer",
//            style: TextStyle(
//                fontFamily: "Exo2",
//                fontSize: 14.0,
//                color: textSecondary54,
//                fontWeight: FontWeight.w500))
      ],
    );
  }

  Column followersWidget() {
    return Column(
      children: <Widget>[
        Text("58k",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("Followers",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500))
      ],
    );
  }
}

class Data {
  String keyName;
  String value;

  Data.fromJson(Map<String, dynamic> json) {
    keyName = json['key_name'].toString();
    value = json['value'].toString();
  }
}
