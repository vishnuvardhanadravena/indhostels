// class ApiConstants {
//   ApiConstants._();
//   static const String domin = false
//       ? 'https://api.indhostel.com'
//       : 'http://192.168.1.12:3000';

//   static const String BaseUrl = "$domin/indhostels";
//   static const String signin = "$domin/indhostels/auth/user/signin";
//   static const String signup = "$domin/indhostels/auth/user/signup";
//   static const String verify = "$domin/indhostels/auth/user/verify";
//   static const String forgotpassword =
//       "$domin/indhostels/auth/user/password/forget";
//   static const String changePassword =
//       "$domin/indhostels/auth/user/password/change";
//   static const String logout = "$domin/indhostels/auth/user/logout";
//   //profile
//   static const String loadprofile = "$domin/indhostels/auth/user/me";
//   static const String updateprofile = "$domin/indhostels/auth/user/update";
//   static const String updateprofilePic =
//       "$domin/indhostels/auth/user/profilepic";
//   static const String getTopHstl =
//       "$domin/indhostels/auth/accommodation/topaccommodations";
//   static const String getBudgetHstl = "$domin/indhostels/auth/accommodation";
//   static const String getAcomodationdetailes =
//       "$domin/indhostels/auth/accommodation";
//   static const String getUserlikedAcommodations =
//       "$domin/indhostels/auth/accommodation/user-liked-accommodation";
//   static const String addtowishlist = "$domin/indhostels/auth/user/wishlist";
//   static const String deletetowishlist =
//       "$domin/indhostels/auth/user/deletewishlist";
//   static const String searchHotels =
//       "$domin/indhostels/auth/accommodation/productfilter";
//   static const String globalSearch =
//       "$domin/indhostels/auth/accommodation/advanced-search";
//   static const String recentsearches =
//       "$domin/indhostels/auth/accommodation/searches";
//   static const String recentviews =
//       "$domin/indhostels/auth/accommodation/recentlyviews";
// }
class ApiConstants {
  ApiConstants._();

  /// ───────────────── ENVIRONMENT ─────────────────

  /// true → production
  /// false → local development
  static const bool isProduction = false;

  /// ───────────────── BASE DOMAINS ─────────────────

  static const String _devDomain = "http://192.168.1.12:3000";
  static const String _prodDomain = "https://api.indhostel.com";

  static String get domain => isProduction ? _prodDomain : _devDomain;

  /// ───────────────── BASE API ─────────────────

  static String get baseUrl => "$domain/indhostels";

  /// ───────────────── AUTH ─────────────────

  static String get signin => "$baseUrl/auth/user/signin";
  static String get signup => "$baseUrl/auth/user/signup";
  static String get verify => "$baseUrl/auth/user/verify";

  static String get forgotPassword => "$baseUrl/auth/user/password/forget";

  static String get changePassword => "$baseUrl/auth/user/password/change";

  static String get logout => "$baseUrl/auth/user/logout";

  /// ───────────────── PROFILE ─────────────────

  static String get loadProfile => "$baseUrl/auth/user/me";

  static String get updateProfile => "$baseUrl/auth/user/update";

  static String get updateProfilePic => "$baseUrl/auth/user/profilepic";

  /// ───────────────── ACCOMMODATION ─────────────────

  static String get getTopHostels =>
      "$baseUrl/auth/accommodation/topaccommodations";

  static String get getBudgetHostels => "$baseUrl/auth/accommodation";

  static String get getAccommodationDetails => "$baseUrl/auth/accommodation";

  static String get getUserLikedAccommodation =>
      "$baseUrl/auth/accommodation/user-liked-accommodation";

  /// ───────────────── WISHLIST ─────────────────

  static String get addToWishlist => "$baseUrl/auth/user/wishlist";

  static String get deleteFromWishlist => "$baseUrl/auth/user/deletewishlist";

  /// ───────────────── SEARCH ─────────────────

  static String get searchHotels => "$baseUrl/auth/accommodation/productfilter";

  static String get globalSearch =>
      "$baseUrl/auth/accommodation/advanced-search";

  static String get recentSearches => "$baseUrl/auth/accommodation/searches";

  static String get recentViews => "$baseUrl/auth/accommodation/recentlyviews";

  /// ───────────────── REVIEWS ─────────────────

  static String reviews(String propertyId) =>
      // "$baseUrl/auth/accommodation/reviews/all/694250c577b9c513afb1bd85";

  "$baseUrl/auth/accommodation/reviews/all/$propertyId";
}
