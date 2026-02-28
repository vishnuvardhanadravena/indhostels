import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/routing/app_roter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indhostels/services/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup(); // very important

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>())],
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
