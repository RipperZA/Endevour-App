import 'dart:ui';

class Constants {
  //URLs
  static String urlBase = 'https://endevour.co.za/api/';

  static String urlLogin = urlBase + 'login';
  static String urlUpdatePassword = urlBase + 'auth/updatePassword';
  static String urlPing = urlBase + 'auth/ping';
  static String urlPushIdAndToken = urlBase + 'auth/updatePushIdAndToken';
  static String urlLogout = urlBase + 'auth/logout';
  static String urlApplicationUpload = urlBase + 'applications';
  static String urlGetAreaManagerSites = urlBase + 'area_managers/getSitesApi';
  static String urlGetRates = urlBase + 'rates/getRatesApi';

  static String urlNewJobUpload = urlBase + 'work';
  static String urlGetAvailableWork = urlBase + 'work/getAvailableWork';
  static String urlGetJobDetails = urlBase + 'work/';
  static String urlGetJobDetailsAreaManager = urlBase + 'workAreaManager/';
  static String urlAcceptJob = urlBase + 'work/accept/';
  static String urlCancelJob = urlBase + 'work/cancel/';
  static String urlArrivedAtWork = urlBase + 'work/arrived/';
  static String urlLeftWork = urlBase + 'work/left/';
  static String urlAcceptedJobs = urlBase + 'work/acceptedWork';
  static String urlPendingJobs = urlBase + 'work/pendingWork';
  static String urlVerifyArrivedAtWork = urlBase + 'work/verifiedArrived/';
  static String urlVerifyLeftWork = urlBase + 'work/verifiedLeft/';

  //colors
  static const Color clr_purple = const Color(0xFF9C27B0);
  static const Color clr_blue = const Color(0xFF548CFF);
  static const Color clr_red = const Color(0xFFF44336);
  static const Color clr_orange = const Color(0xFFFF682D);
  static const Color clr_light_grey = const Color(0xAAD3D3D3);

  static String isOnBoard = "IS_ONBOARD";
  static String isLoggedIn = "IS_LOGGED_IN";
  static String loggingIn = "LOGGING_IN"; //the app is being opened
  static String loggedInOnce = "LOGGED_IN_ONCE"; //they have logged in successfully with email/password at least once
  static String storageUserPermissions = "USER_PERMISSIONS";
  static String storageUserRoles = "USER_ROLES";
  static String storageUserToken = "USER_TOKEN";
  static String storageUserName = "USER_NAME";
  static String storageEmail = "USER_EMAIL";
  static String storagePassword = "USER_PASSWORD";
  static String storageUserSurname = "USER_SURNAME";
  static String storageUserVerified = "USER_VERIFIED";

  //Validations REGEX
  static final String PATTERN_EMAIL =
      "^([0-9a-zA-Z]([-.+\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";
  static const String PHOTOSURL = "https://api.unsplash.com/";
  static const String PHOTOS = "photos";

  //Google Maps API Key
  static const String accessKey =
      "f96abcd230664d7cab7ed900470db93878d44b15d672603e8c6817a267a96c78";

  static const String standardErrorMessage =
      "Something Went Wrong. Please Try Again. If the problem continues please contact support";

  static const String oneSignalAppKey = "28fe38a2-d375-4d9f-9b9b-c14eafabfa02";

  static bool isNullEmptyOrFalse(Object o) =>
      o == null || false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object o) =>
      o == null || false == o || 0 == o || "" == o;
}
