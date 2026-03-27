import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static bool get isIOS => Platform.isIOS;

  ///
  static IconData get home => isIOS ? CupertinoIcons.home : Icons.home;

  static IconData get search => isIOS ? CupertinoIcons.search : Icons.search;

  static IconData get profile => isIOS ? CupertinoIcons.person : Icons.person;

  static IconData get settings =>
      isIOS ? CupertinoIcons.settings : Icons.settings;

  static IconData get notifications =>
      isIOS ? CupertinoIcons.bell : Icons.notifications;

  /// ACTIONS
  static IconData get add => isIOS ? CupertinoIcons.add : Icons.add;

  static IconData get edit => isIOS ? CupertinoIcons.pencil : Icons.edit;

  static IconData get delete => isIOS ? CupertinoIcons.delete : Icons.delete;

  static IconData get share => isIOS ? CupertinoIcons.share : Icons.share;

  static IconData get download =>
      isIOS ? CupertinoIcons.cloud_download : Icons.download;

  /// ARROWS
  static IconData get back => isIOS ? CupertinoIcons.back : Icons.arrow_back;

  static IconData get forward =>
      isIOS ? CupertinoIcons.forward : Icons.arrow_forward;

  static IconData get up =>
      isIOS ? CupertinoIcons.up_arrow : Icons.arrow_upward;

  static IconData get down =>
      isIOS ? CupertinoIcons.down_arrow : Icons.arrow_downward;

  /// STATUS
  static IconData get success =>
      isIOS ? CupertinoIcons.check_mark : Icons.check_circle;

  static IconData get error => isIOS ? CupertinoIcons.clear : Icons.error;

  static IconData get warning =>
      isIOS ? CupertinoIcons.exclamationmark_triangle : Icons.warning;

  static IconData get info => isIOS ? CupertinoIcons.info : Icons.info;

  /// MEDIA
  static IconData get camera =>
      isIOS ? CupertinoIcons.camera : Icons.camera_alt;

  static IconData get gallery => isIOS ? CupertinoIcons.photo : Icons.photo;

  static IconData get video =>
      isIOS ? CupertinoIcons.video_camera : Icons.videocam;

  static IconData get mic => isIOS ? CupertinoIcons.mic : Icons.mic;

  /// FILES
  static IconData get file =>
      isIOS ? CupertinoIcons.doc : Icons.insert_drive_file;

  static IconData get folder => isIOS ? CupertinoIcons.folder : Icons.folder;

  static IconData get upload =>
      isIOS ? CupertinoIcons.cloud_upload : Icons.upload;

  /// USER
  static IconData get login =>
      isIOS ? CupertinoIcons.person_crop_circle : Icons.login;

  static IconData get logout =>
      isIOS ? CupertinoIcons.square_arrow_right : Icons.logout;

  static IconData get lock => isIOS ? CupertinoIcons.lock : Icons.lock;

  /// SOCIAL
  static IconData get like => isIOS ? CupertinoIcons.heart : Icons.favorite;

  static IconData get unlike =>
      isIOS ? CupertinoIcons.heart_slash : Icons.favorite_border;

  static IconData get comment =>
      isIOS ? CupertinoIcons.chat_bubble : Icons.comment;

  static IconData get bookmark =>
      isIOS ? CupertinoIcons.bookmark : Icons.bookmark;

  /// TRANSPORT
  static IconData get location =>
      isIOS ? CupertinoIcons.location : Icons.location_on;

  static IconData get map => isIOS ? CupertinoIcons.map : Icons.map;

  static IconData get car => isIOS ? CupertinoIcons.car : Icons.directions_car;

  static IconData get flight => isIOS ? CupertinoIcons.airplane : Icons.flight;

  /// TIME
  static IconData get calendar =>
      isIOS ? CupertinoIcons.calendar : Icons.calendar_today;

  static IconData get clock => isIOS ? CupertinoIcons.time : Icons.access_time;

  /// SYSTEM
  static IconData get refresh => isIOS ? CupertinoIcons.refresh : Icons.refresh;

  static IconData get close => isIOS ? CupertinoIcons.clear : Icons.close;

  static IconData get menu => isIOS ? CupertinoIcons.bars : Icons.menu;

  static IconData get more => isIOS ? CupertinoIcons.ellipsis : Icons.more_vert;

  static IconData get filter =>
      isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.filter_list;

  static IconData get sort =>
      isIOS ? CupertinoIcons.arrow_up_arrow_down : Icons.sort;

  static IconData get visibility =>
      isIOS ? CupertinoIcons.eye : Icons.visibility;

  static IconData get visibilityOff =>
      isIOS ? CupertinoIcons.eye_slash : Icons.visibility_off;
  static IconData get hotel =>
      isIOS ? CupertinoIcons.building_2_fill : Icons.hotel;
  static IconData get bed =>
      isIOS ? CupertinoIcons.bed_double_fill : Icons.bed_outlined;
  static IconData wishlist(bool isWishlisted) => isIOS
      ? (isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart)
      : (isWishlisted ? Icons.favorite : Icons.favorite_border);
}
