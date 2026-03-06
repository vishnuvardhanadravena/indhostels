import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/bloc/profile/profile_state.dart';
import 'package:indhostels/data/models/profile_models/profile_req.dart';
import 'package:indhostels/data/models/profile_models/profile_res.dart';
import 'package:indhostels/data/repo/profile_repo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onLoadProfile);
    on<ProfileUpdateEvent>(_updateUser);
    on<ProfileImgUpdateEvent>(_onupdateProfileImg);
  }

  Future<void> _onLoadProfile(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final profile = await repository.loadUserDetails();

      UserSession().setUser(profile);

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError("Failed to load profile"));
    }
  }

  Future<void> _onupdateProfileImg(
    ProfileImgUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileImgLoading());

    try {
      final response = await repository.uploadProfileImg(profile: event.img);

      if (response["success"] == true) {
        final updatedUser = UserSession().user?.copyWith(
          profileUrl: response["image"],
        );

        if (updatedUser != null) {
          UserSession().setUser(updatedUser);
        }

        emit(ProfileImgLoaded(updatedUser));
      } else {
        emit(ProfileError(response["message"] ?? "Upload failed"));
      }
    } catch (e) {
      emit(ProfileError("Failed to upload profile image"));
    }
  }

  Future<void> _updateUser(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileupdateLoading());

    try {
      final response = await repository.updateUserProfile(
        profile: ProfileUpdateRequest(
          fullname: event.name ?? "",
          state: event.state ?? "",
          city: event.city ?? "",
          gender: event.gender ?? "",
          email: event.email ?? "",
        ),
      );

      final profile = UserProfile(
        email: event.email,
        fullname: event.name,
        gender: event.gender,
        phone: event.phone,
        location: UserLocation(
          city: event.city ?? "",
          state: event.state ?? "",
        ),
        id: UserSession().user?.id ?? "",
        profileUrl: UserSession().user?.profileUrl ?? "",
      );

      /// check API success
      if (response["success"] == true) {
        /// update session
        UserSession().setUser(profile);

        emit(ProfileUpdateSuccess(response["message"]));
      } else {
        emit(ProfileError(response["message"] ?? "Profile update failed"));
      }
    } catch (e) {
      emit(ProfileError("Failed to update profile"));
    }
  }
}

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();
  UserProfile? user;  
  bool get isLoggedIn => user != null;
  Future<void> setUser(UserProfile profile) async {
    user = profile;
  }

  Future<void> clear() async {
    user = null;
  }
}
