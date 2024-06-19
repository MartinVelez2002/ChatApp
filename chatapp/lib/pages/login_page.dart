import 'package:chatapp/consts.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/navegation_service.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:chatapp/widgets/custom_form_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  late DatabaseService _databaseService;
  late AuthService _authService;
  late NavegationService _navegationService;
  late AlertService _alertService;

  User? _user;
  String? email, password;
  bool isloading = false;
  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    _databaseService = _getIt.get<DatabaseService>();
    _authService = _getIt.get<AuthService>();
    _navegationService = _getIt.get<NavegationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headerText(),
            if (!isloading) _loginForm(),
            if (!isloading) _createAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Bienvenido de vuelta",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Tiempo sin verte",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.4,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormFieldPassword(
              hintText: "Contraseña",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obscureText: true,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            _loginButton(),
            const Text("----------- o -----------"),
            _loginWithGoogle(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            bool result = await _authService.login(email!, password!);

            if (result) {
              _alertService.showToast(
                  text: "Sesión Iniciada", icon: Icons.verified_sharp);
              _navegationService.pushReplacementNamed("/home");
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child:
            const Text("Iniciar Sesión", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _createAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("¿Aún no tienes una cuenta?",
              style: TextStyle(fontSize: 14)),
          GestureDetector(
            onTap: () {
              _navegationService.pushNamed("/register");
            },
            child: const Text(
              "Regístrate",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }

  Widget _loginWithGoogle() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Iniciar sesión con Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(_googleAuthProvider);
      final User? user = userCredential.user;

      if (user != null) {
        _databaseService.createUserProfile(
          userProfile: UserProfile(
              uid: user.uid,
              name: user.displayName,
              pfpURL: user.photoURL,
              email: user.email),
        );

        // Navegar a la pantalla principal o realizar otras acciones después del inicio de sesión
        _alertService.showToast(
            text: "Sesión Iniciada con Google", icon: Icons.verified_sharp);
        _navegationService.pushReplacementNamed("/home");
      }
    } catch (error) {
      print(error);
    }
  }
}
