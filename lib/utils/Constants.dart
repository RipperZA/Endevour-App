import 'dart:ui';
import '../config.dart';

class Constants {
  //URLs
  static final String urlBase = 'https://endevour.co.za/api/';

  static final String urlLogin = urlBase + 'login';
  static final String urlResetPassword = urlBase + 'password/email';
  static final String urlUpdatePassword = urlBase + 'auth/updatePassword';
  static final String urlPing = urlBase + 'auth/ping';
  static final String urlPushIdAndToken = urlBase + 'auth/updatePushIdAndToken';
  static final String urlLogout = urlBase + 'auth/logout';
  static final String urlProfile = urlBase + 'user/profile';
  static final String urlProfilePicture = urlBase + 'user/profilePicture';
  static final String urlApplicationUpload = urlBase + 'applications';
  static final String urlGetAreaManagerSites =
      urlBase + 'area_managers/getSitesApi';
  static final String urlGetNotificationCount =
      urlBase + 'work/getNotificationCount';
  static final String urlGetRates = urlBase + 'rates/getRatesApi';

  static final String urlNewJobUpload = urlBase + 'work';
  static final String urlGetAvailableWork = urlBase + 'work/getAvailableWork';
  static final String urlGetJobDetails = urlBase + 'work/';
  static final String urlGetJobDetailsSingle = urlBase + 'workSingle/';
  static final String urlGetJobDetailsAreaManager =
      urlBase + 'workAreaManager/';
  static final String urlAcceptJob = urlBase + 'work/accept/';
  static final String urlCancelJob = urlBase + 'work/cancel/';
  static final String urlArrivedAtWork = urlBase + 'work/arrived/';
  static final String urlLeftWork = urlBase + 'work/left/';
  static final String urlAcceptedJobs = urlBase + 'work/acceptedWork';
  static final String urlCompletedJobs = urlBase + 'work/completedWork';
  static final String urlPendingJobs = urlBase + 'work/pendingWork';
  static final String urlCreatedJobs = urlBase + 'work/createdWork';
  static final String urlCancelledJobs = urlBase + 'work/cancelledWork';
  static final String urlVerifyArrivedAtWork =
      urlBase + 'work/verifiedArrived/';
  static final String urlVerifyLeftWork = urlBase + 'work/verifiedLeft/';

  //colors
  static const Color clr_purple = const Color(0xFF9C27B0);
  static const Color clr_blue = const Color(0xFF548CFF);
  static const Color clr_red = const Color(0xFFF44336);
  static const Color clr_orange = const Color(0xFFFF682D);
  static const Color clr_light_grey = const Color(0xAAD3D3D3);

  static final String isOnBoard = "IS_ONBOARD";
  static final String isLoggedIn = "IS_LOGGED_IN";
  static final String loggingIn = "LOGGING_IN"; //the app is being opened
  static final String loggedInOnce =
      "LOGGED_IN_ONCE"; //they have logged in successfully with email/password at least once
  static final String storageUserPermissions = "USER_PERMISSIONS";
  static final String storageUserRoles = "USER_ROLES";
  static final String storageUserToken = "USER_TOKEN";
  static final String storageUserName = "USER_NAME";
  static final String storageEmail = "USER_EMAIL";
  static final String storagePassword = "USER_PASSWORD";
  static final String storageUserSurname = "USER_SURNAME";
  static final String storageUserVerified = "USER_VERIFIED";

  //Validations REGEX
  static final String PATTERN_EMAIL =
      "^([0-9a-zA-Z]([-.+\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";
  static const String PHOTOSURL = "https://api.unsplash.com/";
  static const String PHOTOS = "photos";

  //Google Maps API Key
  static const String accessKey = Config.accessKey;

  static const String standardErrorMessage =
      "Something Went Wrong. Please Try Again. If the problem continues please contact support";

  static const String oneSignalAppKey = Config.oneSignalAppKey;

  static bool isNullEmptyOrFalse(Object o) => false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object o) =>
      false == o || 0 == o || "" == o;
}
