import 'dart:io';

import 'package:indhostels/data/models/profile_models/profile_req.dart';
import 'package:indhostels/data/models/profile_models/profile_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class ProfileRepository {
  final ApiClient api;
  ProfileRepository(this.api);
  Future<UserProfile> loadUserDetails() async {
    final response = await api.get(ApiConstants.loadProfile);

    return UserProfile.fromApiResponse(response.data);
  }
  Future<dynamic> updateUserProfile({
    required ProfileUpdateRequest profile,
  }) async {
    final response = await api.put(
      ApiConstants.updateProfile,
      data: profile.toJson(),
    );
    return response.data;
  }
  Future<dynamic> uploadProfileImg({required File profile}) async {
    final response = await api.multipart(
      ApiConstants.updateProfilePic, 
      filePath: profile.path,
      fileKey: "image",
      fields: {},
    );

    return response.data;
  }
}
