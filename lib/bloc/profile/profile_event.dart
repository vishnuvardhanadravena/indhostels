import 'dart:io';

abstract class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {}

class ProfileImgUpdateEvent extends ProfileEvent {
  File img;
  ProfileImgUpdateEvent({required this.img});
}

class ProfileUpdateEvent extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final File? profileImage;
  final String? city;
  final String? state;

  ProfileUpdateEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.profileImage,
    this.city,
    this.state,
  });
}
