class UserLocation {
  final String city;
  final String state;

  const UserLocation({required this.city, required this.state});

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'city': city, 'state': state};

  UserLocation copyWith({String? city, String? state}) => UserLocation(
        city: city ?? this.city,
        state: state ?? this.state,
      );
}

class UserProfile {
  final String? id;
  final String? fullname;
  final String? email;
  final String? phone;
  final String? profileUrl;
  final String?gender;
  final UserLocation? location;

  const UserProfile({
    required this.id,
 this.fullname,
     this.email,
     this.phone,
    this.profileUrl,
    this.gender,
  this.location,
  });

  factory UserProfile.fromApiResponse(Map<String, dynamic> json) {
    final user = json['user_response'] as Map<String, dynamic>;
    return UserProfile.fromJson(user);
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['_id'] as String? ?? '',
        fullname: json['fullname'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: (json['phone'] ?? '').toString(),
        profileUrl: json['profileUrl'] as String? ?? '',
        gender: json['gender'] as String? ?? 'male',
        location: UserLocation.fromJson(
          json['location'] as Map<String, dynamic>? ?? {},
        ),
      );

  Map<String, dynamic> toUpdatePayload() => {
        'fullname': fullname,
        'city': location?.city,
        'state': location?.state,
        'gender': gender,
      };

  UserProfile copyWith({
    String? fullname,
    String? profileUrl,
    String? gender,
    UserLocation? location,
  }) =>
      UserProfile(
        id: id,
        fullname: fullname ?? this.fullname,
        email: email,
        phone: phone,
        profileUrl: profileUrl ?? this.profileUrl,
        gender: gender ?? this.gender,
        location: location ?? this.location,
      );
}