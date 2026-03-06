class ApiConstants {
  ApiConstants._();
  static const String domin = false
      ? 'https://api.indhostel.com'
      : 'http://192.168.1.6:3000';

  static const String BaseUrl = "$domin/indhostels";
  static const String signin = "$domin/indhostels/auth/user/signin";
  static const String signup = "$domin/indhostels/auth/user/signup";
  static const String verify = "$domin/indhostels/auth/user/verify";
  static const String forgotpassword =
      "$domin/indhostels/auth/user/password/forget";
  static const String changePassword =
      "$domin/indhostels/auth/user/password/change";
      static const String logout = "$domin/indhostels/auth/user/logout";

  //profile
  static const String loadprofile = "$domin/indhostels/auth/user/me";
  static const String updateprofile = "$domin/indhostels/auth/user/update";
  static const String updateprofilePic =
      "$domin/indhostels/auth/user/profilepic";

  static const String getTopHstl =
      "$domin/indhostels/auth/accommodation/topaccommodations";
  static const String getBudgetHstl = "$domin/indhostels/auth/accommodation";
}
