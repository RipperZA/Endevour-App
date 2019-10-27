import 'dart:ui';

class Constants {
  //URLs
  static String urlBase = 'http://192.168.1.107:8000/api/';

//  static String urlBase = 'http://10.2.2.106:8000/api/';
//  static String urlBase = 'http://10.0.0.161:8000/api/';
  static String urlLogin = urlBase + 'login';
  static String urlApplicationUpload = urlBase + 'applications';
  static String urlGetAreaManagerSites = urlBase + 'area_managers/getSitesApi';
  static String urlGetRates = urlBase + 'rates/getRatesApi';
  static String urlPushIdAndToken = urlBase + 'auth/updatePushIdAndToken';

  static String urlNewJobUpload = urlBase + 'work';
  static String urlGetAvailableWork = urlBase + 'work/getAvailableWork';
  static String urlGetJobDetails = urlBase + 'work/';
  static String urlAcceptJob = urlBase + 'work/accept/';
  static String urlCancelJob = urlBase + 'work/cancel/';
  static String urlArrivedAtWork = urlBase + 'work/arrived/';
  static String urlLeftWork = urlBase + 'work/left/';
  static String urlAcceptedJobs = urlBase + 'work/acceptedWork';

  //colors
  static const Color clr_purple = const Color(0xFF9C27B0);
  static const Color clr_blue = const Color(0xFF548CFF);
  static const Color clr_red = const Color(0xFFF44336);
  static const Color clr_orange = const Color(0xFFFF682D);
  static const Color clr_light_grey = const Color(0xAAD3D3D3);

  static String isOnBoard = "IS_ONBOARD";
  static String isLoggedIn = "IS_LOGGED_IN";

  //Validations REGEX
  static final String PATTERN_EMAIL =
      "^([0-9a-zA-Z]([-.+\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";
  static const String PHOTOSURL = "https://api.unsplash.com/";
  static const String PHOTOS = "photos";

  //Google Maps API Key
  static const String accessKey =
      "f96abcd230664d7cab7ed900470db93878d44b15d672603e8c6817a267a96c78";
}
