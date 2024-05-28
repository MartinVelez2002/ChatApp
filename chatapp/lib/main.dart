import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/navegation_service.dart';
import 'package:chatapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MainApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MainApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  late NavegationService _navegationService;
  late AuthService _authService;

  MainApp({super.key}) {
    _navegationService = _getIt.get<NavegationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navegationService.navigatorKey,
      title: 'Prueba de Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 113, 51, 221)),
        useMaterial3: true,
        textTheme: GoogleFonts.alataTextTheme(),
      ),
      initialRoute: _authService.user != null ? "/home" : "/login",
      routes: _navegationService.routes,
    );
  }
}
