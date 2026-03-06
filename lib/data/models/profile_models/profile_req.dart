
class ProfileUpdateRequest {
  final String fullname;
  final String state;
  final String city;
  final String gender;
  final String email;

  ProfileUpdateRequest({
    required this.fullname,
    required this.state,
    required this.city,
    required this.gender,
    required this.email,
  });

  /// Convert object → JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "state": state,
      "city": city,
      "gender": gender,
      "email": email,
    };
  }

  /// Create object from JSON
  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequest(
      fullname: json['fullname'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      gender: json['gender'] ?? "",
      email: json['email'] ?? "",
    );
  }
}