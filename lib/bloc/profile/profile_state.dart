import 'package:indhostels/data/models/profile_models/profile_res.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileImgLoading extends ProfileState {}

class ProfileupdateLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileImgError extends ProfileState {
  final String message;
  ProfileImgError(this.message);
}

class ProfileImgLoaded extends ProfileState {
  final UserProfile? profile;
   
  ProfileImgLoaded(this.profile);
}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  ProfileUpdateSuccess(this.message);
}
