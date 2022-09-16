import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final client = sb.Supabase.instance.client;

class LoginRequired extends StatelessWidget {
  const LoginRequired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Para esto necesitas iniciar sessión'),
          ElevatedButton(
            onPressed: () async {
              await client.auth.signInWithProvider(sb.Provider.google,
                  options: sb.AuthOptions(
                      redirectTo: 'com.example.honestore://login-callback'));
            },
            child: Text('Continuar con Google'),
          )
        ]);
  }
}
