// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:indhostels/bloc/Serach/search_bloc.dart';
// import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
// import 'package:indhostels/bloc/auth/auth_bloc.dart';
// import 'package:indhostels/bloc/bookings/bookings_bloc.dart';
// import 'package:indhostels/bloc/notification/notification_bloc.dart';
// import 'package:indhostels/bloc/payment/payment_bloc.dart';
// import 'package:indhostels/bloc/profile/profile_bloc.dart';
// import 'package:indhostels/bloc/review/review_bloc.dart';
// import 'package:indhostels/bloc/support/support_bloc.dart';
// import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
// import 'package:indhostels/routing/app_roter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indhostels/services/apiservice/api_client.dart';
// import 'package:indhostels/services/init.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await setup();

//   AppLogger.enableLogs = true;
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
//         BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
//         BlocProvider<AccommodationBloc>(create: (_) => sl<AccommodationBloc>()),
//         BlocProvider<WishlistBloc>(
//           create: (_) => sl<WishlistBloc>()..add(FetchWishlistEvent()),
//         ),
//         BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
//         BlocProvider<ReviewBloc>(create: (_) => sl<ReviewBloc>()),
//         BlocProvider<BookingsBloc>(create: (_) => sl<BookingsBloc>()),
//         BlocProvider<PaymentBloc>(create: (_) => sl<PaymentBloc>()),
//         BlocProvider<NotificationBloc>(create: (_) => sl<NotificationBloc>()),
//         BlocProvider<SupportBloc>(create: (_) => sl<SupportBloc>()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
//       debugShowCheckedModeBanner: false,
//       routerConfig: appRouter,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:indhostels/services/init.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/routing/app_roter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  AppLogger.enableLogs = true;
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_AppRootState>()?.restartApp();
  }

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<AccommodationBloc>()),
        BlocProvider(
          create: (_) => sl<WishlistBloc>()..add(FetchWishlistEvent()),
        ),
        BlocProvider(create: (_) => sl<SearchBloc>()),
        BlocProvider(create: (_) => sl<ReviewBloc>()),
        BlocProvider(create: (_) => sl<BookingsBloc>()),
        BlocProvider(create: (_) => sl<PaymentBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
        BlocProvider(create: (_) => sl<SupportBloc>()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}

Future<void> appLogout(BuildContext context) async {
  await sl<AppSecureStorage>().clearAll();
  await sl.reset();
  await setup();
  AppRoot.restart(context);
}
