import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/bookings/bookings_bloc.dart';
import 'package:indhostels/bloc/notification/notification_bloc.dart';
import 'package:indhostels/bloc/payment/payment_bloc.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/review/review_bloc.dart';
import 'package:indhostels/bloc/support/support_bloc.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
import 'package:indhostels/routing/app_roter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indhostels/services/init.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<void> getUserAddress() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied. Open settings.");
      await Geolocator.openAppSettings();
      return;
    }

    // Get coordinates
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double lng = position.longitude;

    print("Lat: $lat, Lng: $lng");

    // Convert to address
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isEmpty) {
      print("No address found.");
      return;
    }

    Placemark place = placemarks.first;

    print("--- Full Address Info ---");
    print("Name: ${place.name}"); // e.g. "Apple Park"
    print("Street: ${place.street}"); // e.g. "1 Apple Park Way"
    print("Sublocality: ${place.subLocality}"); // Sub-area / neighborhood
    print("Locality/City: ${place.locality}"); // City
    print("District: ${place.subAdministrativeArea}"); // District / County
    print("State: ${place.administrativeArea}"); // State / Province
    print("Postal Code: ${place.postalCode}"); // ZIP / PIN code
    print("Country: ${place.country}"); // e.g. "India"
    print("Country Code: ${place.isoCountryCode}"); // e.g. "IN", "US"
    print("Thoroughfare: ${place.thoroughfare}"); // Road / Street name
    print("Sub-Thoroughfare: ${place.subThoroughfare}");
    placemarks.asMap().forEach((index, place) {
      print("--- Placemark ${index + 1} ---");
      print("Name: ${place.name ?? 'N/A'}");
      print("Street: ${place.street ?? 'N/A'}");
      print("Sublocality: ${place.subLocality ?? 'N/A'}");
      print("Locality/City: ${place.locality ?? 'N/A'}");
      print("District: ${place.subAdministrativeArea ?? 'N/A'}");
      print("State: ${place.administrativeArea ?? 'N/A'}");
      print("Postal Code: ${place.postalCode ?? 'N/A'}");
      print("Country: ${place.country ?? 'N/A'}");
      print("Country Code: ${place.isoCountryCode ?? 'N/A'}");
      print("Thoroughfare: ${place.thoroughfare ?? 'N/A'}");
      print("Sub-Thoroughfare: ${place.subThoroughfare ?? 'N/A'}");
      print("");
    });
  } catch (e) {
    print("Error: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),

        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<AccommodationBloc>(create: (_) => sl<AccommodationBloc>()),
        BlocProvider<WishlistBloc>(
          create: (_) => sl<WishlistBloc>()..add(FetchWishlistEvent()),
        ),
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<ReviewBloc>(create: (_) => sl<ReviewBloc>()),
        BlocProvider<BookingsBloc>(create: (_) => sl<BookingsBloc>()),
        BlocProvider<PaymentBloc>(create: (_) => sl<PaymentBloc>()),
        BlocProvider<NotificationBloc>(create: (_) => sl<NotificationBloc>()),
        BlocProvider<SupportBloc>(create: (_) => sl<SupportBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
