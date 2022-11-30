import 'package:flutter/widgets.dart';
import 'package:honestore/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorService {
  static Map<String, String> translations = {
    'Invalid login credentials': 'Usuario o contraseña no válidos',
    'Password should be at least 6 characters':
        'La contraseña debe tener al menos 6 carácteres',
    'Signup requires a valid password': 'Contraseña no válida',
    'To signup, please provide your email':
        'Tienes que darnos tu email para registrarte',
    'Unable to validate email address: invalid format': 'Email no válido',
    'User already registered': 'Usuario ya registrado'
  };
  static void handleAuthError(BuildContext context, AuthException error) {
    String msg = translate(error.message);
    show(context, msg);
  }

  static String translate(String errorMsg) {
    debugPrint(errorMsg);
    return translations[errorMsg] ?? 'Se ha producido un error';
  }

  static void show(BuildContext? context, String msg) {
    if (context != null) {
      context.showErrorSnackBar(message: msg);
    }
  }
}
