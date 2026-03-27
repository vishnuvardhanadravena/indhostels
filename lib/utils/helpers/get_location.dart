import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:indhostels/services/apiservice/api_client.dart';

Future<UserLocation?> getUserAddress() async {
  try {
    // 1. Check service
    if (!await Geolocator.isLocationServiceEnabled()) {
      AppLogger.warning("Location service disabled", tag: "Location");
      return null;
    }

    // 2. Permission
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.warning("Permission denied", tag: "Location");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.warning("Permission denied forever", tag: "Location");
      await Geolocator.openAppSettings();
      return null;
    }

    // 3. Get position
    final position = await Geolocator.getCurrentPosition(
      locationSettings: _getLocationSettings(),
    );

    final lat = position.latitude;
    final lng = position.longitude;

    // 4. Reverse geocoding
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;

    final place = placemarks.first;

    final address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

    AppLogger.success("Location fetched", tag: "Location");

    return UserLocation(
      latitude: lat,
      longitude: lng,
      address: address,
      city: place.locality ?? "",
      state: place.administrativeArea ?? "",
      country: place.country ?? "",
      postalCode: place.postalCode ?? "",
    );
  } catch (e, s) {
    AppLogger.exception(e, s, tag: "Location");
    return null;
  }
}

LocationSettings _getLocationSettings() {
  if (kIsWeb) {
    return WebSettings(accuracy: LocationAccuracy.high);
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

    case TargetPlatform.iOS:
      return AppleSettings(accuracy: LocationAccuracy.high);

    default:
      return const LocationSettings(accuracy: LocationAccuracy.high);
  }
}

class UserLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });
}
