import 'package:flutter/material.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/services/data_service.dart';
import 'package:honestore/widgets/tab_title.dart';
import 'package:provider/provider.dart';
import 'package:honestore/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final client = sb.Supabase.instance.client;

class MoreTabElement extends StatelessWidget {
  const MoreTabElement(
      {required this.title, this.action, this.forUsers = false, Key? key})
      : super(key: key);

  final String title;
  final void Function()? action;
  final bool forUsers;

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(title),
      onTap: action,
    );
    return forUsers
        ? Consumer<AppState>(builder: (context, appState, child) {
            if (appState.user != null) {
              return tile;
            }
            return Container();
          })
        : tile;
  }
}

class MoreTab extends StatelessWidget {
  const MoreTab({Key? key}) : super(key: key);

  Future<void> _askDeleteConfirmation(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Eliminar cuenta permanentemente"),
            content: const Text(
                "¿Estás seguro? Esta acción eliminará la cuenta y todos tus datos de forma irrerversible"),
            actions: [
              TextButton(
                  onPressed: () {
                    DataService.deleteUser().then((resp) {
                      if (resp.error != null) {
                        context.showErrorSnackBar(
                            message: resp.error.toString());
                      } else {
                        client.auth.signOut();
                        context.showSnackBar(message: 'Cuenta eliminada');
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Eliminar')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TabTitle('Honestore'),
        const Padding(
          padding: EdgeInsets.only(top: 0, right: 16.0, left: 16, bottom: 16),
          child: Text('About honestore'),
        ),
        Expanded(
          child: ListView(children: [
            MoreTabElement(title: 'Mi Cuenta', forUsers: true),
            MoreTabElement(title: 'Enviar sugerencias', forUsers: false),
            MoreTabElement(title: 'Comparte la app', forUsers: false),
            MoreTabElement(
                title: 'Eliminar Cuenta',
                action: () {
                  _askDeleteConfirmation(context);
                },
                forUsers: true),
            Consumer<AppState>(builder: (context, appState, child) {
              if (appState.user != null) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      client.auth.signOut();
                      context.showSnackBar(message: "Sesión cerrada");
                    },
                    child: const Text('Cerrar Sesión'),
                  ),
                );
              }
              return Container();
            }),
          ]),
        ),
      ],
    );
  }
}
