import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/widgets/validated_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:honestore/constants.dart';

final client = sb.Supabase.instance.client;

class LoginRequired extends StatefulWidget {
  const LoginRequired({Key? key}) : super(key: key);

  @override
  State<LoginRequired> createState() => _LoginRequiredState();
}

class _LoginRequiredState extends State<LoginRequired> {
  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  void login() {
    client.auth
        .signIn(email: _emailController.text, password: _passController.text)
        .then((value) {
      if (value.user == null) {
        context.showErrorSnackBar(message: '${value.error?.message}');
        return;
      }
      Provider.of<AppState>(context, listen: false).loginUser(value.user!);
    });
  }

  void singUp() {
    client.auth
        .signUp(_emailController.text, _passController.text)
        .then((value) {
      if (value.user == null) {
        context.showErrorSnackBar(message: '${value.error?.message}');
        return;
      }
      Provider.of<AppState>(context, listen: false).loginUser(value.user!);
    });
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
    return Column(
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
              padding: const EdgeInsets.only(bottom: 0, left: 24, right: 24),
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
              ElevatedButton(
                  onPressed: singUp, child: const Text('Crear cuenta')),
              const Padding(padding: EdgeInsets.only(left: 10)),
              ElevatedButton(
                  onPressed: login, child: const Text('Iniciar Sesión'))
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
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
              await client.auth.signInWithProvider(sb.Provider.google,
                  options: sb.AuthOptions(
                      redirectTo: 'app.honestore.android://login-callback'));
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              FaIcon(FontAwesomeIcons.google),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('Continuar con Google'),
            ]),
          )
        ]);
  }
}
