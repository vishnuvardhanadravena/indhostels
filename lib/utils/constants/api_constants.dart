class ApiConstants {
  ApiConstants._();

  /// ───────────────── ENVIRONMENT ─────────────────

  static const bool isProduction = false;

  /// ───────────────── BASE DOMAINS ─────────────────

  static const String _devDomain = "http://192.168.1.47:3000";
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
  static String get fetchWishlist => "$baseUrl/auth/user/getwishlist";
  // 691429edaee09f117de500b2
  // 69142c29537676fc304e4230
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

  /// ───────────────── BOOKINGS ─────────────────

  static String myBookings() => "$baseUrl/auth/user/booking/mybookings";

  static String bookingDetails(String id) => "$baseUrl/auth/user/booking/$id";

  /// ───────────────── BOOKINGS ─────────────────

  static String createBooking(String propertyId, String roomId) =>
      "$baseUrl/auth/user/booking/$propertyId/$roomId";
  static String verifypayment() => "$baseUrl/auth/user/booking/verify-payment";
  static String createReview(String propertyId) {
    return "/indhostels/auth/accommodation/review/$propertyId";
  }

  static String downloadinvoice(String propertyId) {
    return "/indhostels/auth/user/booking/generate-invoice/$propertyId";
  }

  static String getNotifications() {
    return "/indhostels/auth/user/notification";
  }

  static String createissue() {
    return "/indhostels/auth/helpandsupport/create-ticket-and-messages";
  }

  static String getticketmessges() {
    return "/indhostels/auth/helpandsupport/get-tickets-and-messages";
  }

  static String getNotificationById(String id) =>
      "/indhostels/auth/user/notification/$id";
}
