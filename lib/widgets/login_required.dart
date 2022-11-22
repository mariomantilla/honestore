import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honestore/helpers/url_helper.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/services/error_service.dart';
import 'package:honestore/widgets/async_button.dart';
import 'package:honestore/widgets/validated_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:honestore/constants.dart';

import '../services/analytics_service.dart';

final client = sb.Supabase.instance.client;

class LoginRequired extends StatefulWidget {
  const LoginRequired({Key? key}) : super(key: key);

  @override
  State<LoginRequired> createState() => _LoginRequiredState();
}

class _LoginRequiredState extends State<LoginRequired> {
  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  Future validateCredentials() {
    return client.auth.signInWithPassword(
        email: _emailController.text, password: _passController.text);
  }

  login(dynamic response) {
    Analytics.t("Log in");
    Provider.of<AppState>(context, listen: false).loginUser(response.user!);
  }

  handleError(error) {
    ErrorService.handleAuthError(context, error);
    _passController.text = '';
  }

  Future signUp() {
    return client.auth
        .signUp(email: _emailController.text, password: _passController.text);
  }

  signUpSucccess(response) {
    Analytics.t("Create account");
    Provider.of<AppState>(context, listen: false).loginUser(response.user!);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Requerido';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Email inválido';
    }
    // return null if the text is valid
    return null;
  }

  String? validatePass(String value) {
    if (value.isEmpty) {
      return 'Requerido';
    }
    if (value.length < 6) {
      return 'Demasiado corta';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('Para esto necesitas iniciar sessión'),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 24, right: 24, bottom: 6),
                  child: ValidatedField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    validation: validateEmail,
                  )),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 0, left: 24, right: 24),
                  child: ValidatedField(
                    label: 'Contraseña',
                    controller: _passController,
                    icon: Icons.key,
                    validation: validatePass,
                    password: true,
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AsyncButton(
                      'Crear cuenta', signUp, signUpSucccess, handleError),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  AsyncButton(
                      'Iniciar Sesión', validateCredentials, login, handleError)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 8, left: 16, right: 16),
                child: Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text('o', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider())
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await client.auth.signInWithOAuth(sb.Provider.google,
                      redirectTo: 'app.honestore.android://login-callback');
                  Analytics.t("Continue with Google");
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  FaIcon(FontAwesomeIcons.google),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text('Continuar con Google'),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: InkWell(
                  onTap: openUrlCallback('https://honestore.app/privacy'),
                  child: const Text(
                    'Política de Privacidad',
                    style: TextStyle(color: CustomColors.primary),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
