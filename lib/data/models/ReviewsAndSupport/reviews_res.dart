class ReviewsRes {
  final bool success;
  final int statuscode;
  final String message;
  final ReviewsData? data;

  ReviewsRes({
    required this.success,
    required this.statuscode,
    required this.message,
    this.data,
  });

  factory ReviewsRes.fromJson(Map<String, dynamic> json) => ReviewsRes(
    success: json['success'] as bool? ?? false,
    statuscode: json['statuscode'] as int? ?? 0,
    message: json['message'] as String? ?? '',
    data: json['data'] != null
        ? ReviewsData.fromJson(json['data'] as Map<String, dynamic>)
        : null,
  );
}

class ReviewsData {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int count;
  final int totalRatings;
  final int totalPages;
  final int page;

  ReviewsData({
    required this.reviews,
    required this.averageRating,
    required this.count,
    required this.totalRatings,
    required this.totalPages,
    required this.page,
  });

  factory ReviewsData.fromJson(Map<String, dynamic> json) => ReviewsData(
    reviews: (json['reviews'] as List<dynamic>? ?? [])
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    count: json['count'] as int? ?? 0,
    totalRatings: json['totalRatings'] as int? ?? 0,
    totalPages: json['totalpages'] as int? ?? 1,
    page: json['page'] as int? ?? 1,
  );
}

class ReviewModel {
  final String id;
  final String propertyId;
  final ReviewUser user;
  final String aboutStay;
  final int rating;
  final int helpful;
  final int notHelpful;
  final bool verifiedStay;
  final String stayedDate;
  final String roomType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.propertyId,
    required this.user,
    required this.aboutStay,
    required this.rating,
    required this.helpful,
    required this.notHelpful,
    required this.verifiedStay,
    required this.stayedDate,
    required this.roomType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['_id'] as String? ?? '',
    propertyId: json['propertyid'] as String? ?? '',
    user: ReviewUser.fromJson(json['userId'] as Map<String, dynamic>),
    aboutStay: json['aboutstay'] as String? ?? '',
    rating: json['rating'] as int? ?? 0,
    helpful: json['helpful'] as int? ?? 0,
    notHelpful: json['nothelpful'] as int? ?? 0,
    verifiedStay: json['verifiedstay'] as bool? ?? false,
    stayedDate: json['stayeddate'] as String? ?? '',
    roomType: json['roomtype'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
  );

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${createdAt.day} ${months[createdAt.month - 1]}, ${createdAt.year}';
  }
}

class ReviewUser {
  final String id;
  final String fullname;
  final String email;
  final String profileUrl;

  ReviewUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.profileUrl,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
    id: json['_id'] as String? ?? '',
    fullname: json['fullname'] as String? ?? '',
    email: json['email'] as String? ?? '',
    profileUrl: json['profileUrl'] as String? ?? '',
  );
}
