import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart'
    as roommodel;
import 'package:indhostels/data/models/bookings/booking_res.dart';
import 'package:indhostels/data/models/notification/notification_res.dart';
import 'package:indhostels/pages/acommadtion/acommadation_detailes.dart';
import 'package:indhostels/pages/acommadtion/roomDetails_Screen.dart';
import 'package:indhostels/pages/acommadtion/rooms.dart';
import 'package:indhostels/pages/auth/change_password.dart';
import 'package:indhostels/pages/auth/forgotpass.dart';
import 'package:indhostels/pages/auth/login.dart';
import 'package:indhostels/pages/auth/otpverifyScreen.dart';
import 'package:indhostels/pages/bookings/booking_details.dart';
import 'package:indhostels/pages/category/category_screen.dart';
import 'package:indhostels/pages/category/category_search_screen.dart';
import 'package:indhostels/pages/bookings/bookings.dart';
import 'package:indhostels/pages/dashbord/dashbord.dart';
import 'package:indhostels/pages/dashbord/home.dart';
import 'package:indhostels/pages/payment/payment_success_screen.dart';
import 'package:indhostels/pages/payment/payment_summary.dart';
import 'package:indhostels/pages/profile/edit_profile.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/pages/dashbord/search.dart';
import 'package:indhostels/on_boardingScreen.dart';
import 'package:indhostels/pages/notifications/notificationDetails.dart';
import 'package:indhostels/pages/notifications/notifications.dart';
import 'package:indhostels/pages/notifications/review_update_screen.dart';
import 'package:indhostels/pages/notifications/reviews_Screen.dart';
import 'package:indhostels/pages/support/SupportTicketsScreen.dart';
import 'package:indhostels/pages/support/support_Screen.dart';
import 'package:indhostels/pages/wishlist/wishlistScreen.dart';
import 'package:indhostels/spalshScreen.dart';
import 'package:indhostels/routing/route_constants.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  initialLocation: RouteList.splash,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: RouteList.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: RouteList.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: RouteList.login,
      builder: (context, state) => const LoginScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainNavBarScreen(child: child);
      },
      routes: [
        GoRoute(
          path: RouteList.home,
          name: RouteList.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteList.search,
          name: RouteList.search,
          builder: (context, state) => const SearchScreen(),
        ),

        GoRoute(
          path: RouteList.bookings,
          name: RouteList.bookings,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: RouteList.profile,
          name: RouteList.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: RouteList.otp,
      name: RouteList.otp,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final phone = data["phone"] as String;
        final type = data["type"] as LoginType;

        return Otpverifyscreen(phone: phone, type: type);
      },
    ),
    GoRoute(
      path: RouteList.forgotPassword,
      name: RouteList.forgotPassword,
      builder: (context, state) => const Forgotpassword(),
    ),
    GoRoute(
      path: RouteList.changePassword,
      name: RouteList.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: RouteList.editProfile,
      name: RouteList.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),

    GoRoute(
      path: RouteList.categoryScreen,
      name: RouteList.categoryScreen,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final title = data["title"] as String;

        return HotelsScreen(title: title);
      },
    ),
    GoRoute(
      path: RouteList.hotelListing,
      name: RouteList.hotelListing,
      builder: (context, state) {
        return HotelListingScreen();
      },
    ),
    GoRoute(
      path: RouteList.accommodationDetails,
      name: RouteList.accommodationDetails,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final id = data["id"] as String;
        return AcommadationDetailesScreen(id: id);
      },
    ),
    GoRoute(
      path: RouteList.rooms,
      name: RouteList.rooms,
      builder: (context, state) {
        final args = state.extra as RoomsArgs?;

        if (args == null) {
          return const Scaffold(body: Center(child: Text("Invalid room data")));
        }

        return RoomsScreen(
          // rooms: args.rooms,
          acommodation: args.acommodation,
        );
      },
    ),

    GoRoute(
      path: RouteList.roomDetails,
      name: RouteList.roomDetails,
      builder: (context, state) {
        final args = state.extra as RoomDetailArgs?;
        if (args == null) {
          return const Scaffold(body: Center(child: Text("Invalid Room Data")));
        }
        return RoomDetailScreen(
          room: args.room,
          acommodation: args.acommodation,

          // pgName: args.pgName,
          // location: args.location,
          // checkInTime: args.checkInTime,
          // cancellationPolicy: args.cancellationPolicy,
          // staytype: args.staytype,
        );
      },
    ),
    GoRoute(
      path: RouteList.reviews,
      name: RouteList.reviews,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final id = data["id"] as String;
        return ReviewsScreen(id: id);
      },
    ),
    GoRoute(
      path: RouteList.updatereviews,
      name: RouteList.updatereviews,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final booking = data["booking"] as BookingModel;

        return MyReviewScreen(booking: booking);
      },
    ),

    GoRoute(
      path: RouteList.bookingDetails,
      name: RouteList.bookingDetails,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final bookingId = data["bookingId"] as String;
        return BookingDetailScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: RouteList.wishlist,
      name: RouteList.wishlist,
      builder: (context, state) => const Wishlistscreen(),
    ),
    GoRoute(
      path: RouteList.bookingSummary,
      name: RouteList.bookingSummary,
      builder: (ctx, state) {
        final data = state.extra as Map<String, dynamic>;

        final room = data["room"] as roommodel.RoomModel;
        // final stayType = data["stayType"] as String;
        // final pricePerNight = data["pricePerNight"] as double;
        // final cancellationPolicy = data["cancellationPolicy"] as String;
        // final checkInTime = data["checkInTime"] as String;
        final accommodation = data["accommodation"] as Acommodation;

        return BookingSummaryScreen(
          room: room,
          // stayType: stayType,
          // pricePerNight: pricePerNight,
          // cancellationPolicy: cancellationPolicy,
          // checkInTime: checkInTime,
          accommodation: accommodation,
        );
      },
    ),
    GoRoute(
      path: RouteList.paymentsuccess,
      name: RouteList.paymentsuccess,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const PaymentSuccessScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final size = MediaQuery.of(context).size;

                final maxRadius = sqrt(
                  (size.width * size.width) + (size.height * size.height),
                );

                final radius =
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ).value *
                    maxRadius;

                return ClipPath(
                  clipper: _CircularRevealClipper(
                    radius: radius,
                    center: Offset(size.width / 2, size.height / 2),
                  ),
                  child: child,
                );
              },
            );
          },
        );
      },
    ),
    GoRoute(
      path: RouteList.notifications,
      name: RouteList.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: RouteList.notificationDetail,
      name: RouteList.notificationDetail,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final notificationid = data["notificationid"] as String;
        final heroIndex = data["heroIndex"] as int;

        return CustomTransitionPage(
          key: state.pageKey,
          child: NotificationDetailPage(
            notificationId: notificationid,
            heroIndex: heroIndex,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: RouteList.tickets,
      name: RouteList.tickets,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: RouteList.help,
      name: RouteList.help,
      builder: (context, state) => const SupportTicketsScreen(),
    ),
  ],
);

class RoomDetailArgs {
  final roommodel.RoomModel room;
  final Acommodation? acommodation;

  RoomDetailArgs({required this.room, this.acommodation});
}

class RoomsArgs {
  final List<roommodel.RoomModel> rooms;
  final Acommodation? acommodation;

  RoomsArgs({required this.rooms, required this.acommodation});
}

class _CircularRevealClipper extends CustomClipper<Path> {
  final double radius;
  final Offset center;

  _CircularRevealClipper({required this.radius, required this.center});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircularRevealClipper old) =>
      old.radius != radius || old.center != center;
}
