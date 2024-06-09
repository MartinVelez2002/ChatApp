import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/navegation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavegationService _navegationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navegationService = _getIt.get<NavegationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Bandeja de Mensajes",
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  bool result = await _authService.logout();
                  if (result) {
                    _alertService.showToast(
                        text: "Se ha cerrado la sesión",
                        icon: Icons.waving_hand);
                    _navegationService.pushReplacementNamed("/login");
                  }
                },
                color: Colors.red,
                icon: const Icon(
                  Icons.logout,
                ))
          ]),
    );
  }
}
