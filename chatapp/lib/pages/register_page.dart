import 'dart:io';
import 'package:chatapp/consts.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/media_service.dart';
import 'package:chatapp/services/navegation_service.dart';
import 'package:chatapp/utils.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late AuthService _authService;
  late MediaService _mediaService;
  late NavegationService _navegationService;
  late AlertService _alerService;

  String? email, password, name;
  File? selectedImage;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navegationService = _getIt.get<NavegationService>();
    _authService = _getIt.get<AuthService>();
    _alerService = _getIt.get<AlertService>();
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                _headerText(),
                if (!isloading) _registerForm(),
                if (!isloading) _loginAccountLink(),
                if (isloading)
                  const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  )),
              ],
            )));
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
            "Formulario para crear una cuenta",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.6,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05,
        ),
        child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _pfpSelectionFiled(),
                CustomFormField(
                  hintText: "Usuario: ",
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  validationRegEx: NAME_VALIDATION_REGEX,
                  onSaved: (value) {
                    setState(
                      () {
                        name = value;
                      },
                    );
                  },
                  
                ),
                CustomFormField(
                  hintText: "Email: ",
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  validationRegEx: EMAIL_VALIDATION_REGEX,
                  onSaved: (value) {
                    setState(
                      () {
                        email = value;
                      },
                    );
                  },
                  
                ),
                CustomFormField(
                  hintText: "Contraseña: ",
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  validationRegEx: PASSWORD_VALIDATION_REGEX,
                  obscureText: true,
                  onSaved: (value) {
                      setState(
                      () {
                        password = value;
                      },
                    );

                  },    
                  
                ),
                _registerButton()
              ],
            )));
  }

  Widget _pfpSelectionFiled() {
    return GestureDetector(
      onTap: () async {
        File? file = await MediaService().getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () async {
            setState(() {
              isloading = true;
            });
            try {
              if ((_registerFormKey.currentState?.validate() ?? false) &&
                  selectedImage != null) {
                _registerFormKey.currentState?.save();
                bool result = await _authService.signup(email!, password!);
                if (result) {
                  print(result);
                }
              }
            } catch (e) {
              print(e);
            }
            setState(() {
              isloading = false;
            });
          },
          child: const Text(
            "Registrar",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("¿Ya tienes una cuenta?", style: TextStyle(fontSize: 14)),
        GestureDetector(
          onTap: () {
            _navegationService.goBack();
          },
          child: const Text(
            "Logueate",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    ));
  }
}
