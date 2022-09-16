import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:honestore/constants.dart';
import 'package:provider/provider.dart' as p;

import '../models/app_state.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      p.Provider.of<AppState>(context, listen: false).loginUser(user);
    }
  }

  @override
  void onUnauthenticated() {
    p.Provider.of<AppState>(context, listen: false).logOut();
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
