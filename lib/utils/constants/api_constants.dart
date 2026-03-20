class ApiConstants {
  ApiConstants._();

  /// ───────────────── ENVIRONMENT ─────────────────

  static const bool isProduction = false;

  /// ───────────────── DOMAINS ─────────────────

  static const String _devDomain = "http://192.168.1.47:3000";
  // static const String _devDomain = "http://10.0.2.2:3000"; // emulator

  static const String _prodDomain = "https://api.indhostel.com";

  static String get domain => isProduction ? _prodDomain : _devDomain;

  /// ───────────────── BASE ─────────────────

  static String get baseUrl => "$domain/indhostels";

  /// ───────────────── COMMON BUILDERS (PRO LEVEL) ─────────────────

  static String auth(String path) => "$baseUrl/auth/user/$path";

  static String accommodation(String path) =>
      "$baseUrl/auth/accommodation/$path";

  static String booking(String path) =>
      "$baseUrl/auth/user/booking/$path";

  static String help(String path) =>
      "$baseUrl/auth/helpandsupport/$path";

  static String notification(String path) =>
      "$baseUrl/auth/user/notification/$path";

  /// ───────────────── AUTH ─────────────────

  static String get signin => auth("signin");
  static String get signup => auth("signup");
  static String get verify => auth("verify");
  static String get forgotPassword => auth("password/forget");
  static String get changePassword => auth("password/change");
  static String get logout => auth("logout");
  static String get deactivate => auth("deactivateaccount");

  /// ───────────────── PROFILE ─────────────────

  static String get loadProfile => auth("me");
  static String get updateProfile => auth("update");
  static String get updateProfilePic => auth("profilepic");

  /// ───────────────── ACCOMMODATION ─────────────────

  static String get getTopHostels =>
      accommodation("topaccommodations");

  static String get getBudgetHostels =>
      accommodation("");

  static String get getAccommodationDetails =>
      accommodation("");

  static String get getUserLikedAccommodation =>
      accommodation("user-liked-accommodation");

  /// 🔥 FILTER LOCATIONS (YOUR NEW API)
  static String get locations =>
      accommodation("filternames");

  /// ───────────────── SEARCH ─────────────────

  static String get searchHotels =>
      accommodation("productfilter");

  static String get globalSearch =>
      accommodation("advanced-search");

  static String get recentSearches =>
      accommodation("searches");

  static String get recentViews =>
      accommodation("recentlyviews");

  /// ───────────────── REVIEWS ─────────────────

  static String reviews(String propertyId) =>
      accommodation("reviews/all/$propertyId");

  static String createReview(String propertyId) =>
      accommodation("review/$propertyId");

  /// ───────────────── BOOKINGS ─────────────────

  static String get myBookings =>
      booking("mybookings");

  static String bookingDetails(String id) =>
      booking(id);

  static String createBooking(String propertyId, String roomId) =>
      booking("$propertyId/$roomId");

  static String get verifyPayment =>
      booking("verify-payment");

  static String downloadInvoice(String bookingId) =>
      booking("generate-invoice/$bookingId");

  /// ───────────────── WISHLIST ─────────────────

  static String get addToWishlist =>
      auth("wishlist");

  static String get deleteFromWishlist =>
      auth("deletewishlist");

  static String get fetchWishlist =>
      auth("getwishlist");

  /// ───────────────── NOTIFICATIONS ─────────────────

  static String get getNotifications =>
      notification("");

  static String getNotificationById(String id) =>
      notification(id);

  /// ───────────────── HELP & SUPPORT ─────────────────

  static String get createIssue =>
      help("create-ticket-and-messages");

  static String get getTicketMessages =>
      help("get-tickets-and-messages");
        static String get contactUsQuery =>
      auth("query");
}