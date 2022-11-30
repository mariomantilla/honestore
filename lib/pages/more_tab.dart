import 'package:flutter/material.dart';
import 'package:honestore/helpers/url_helper.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/services/data_service.dart';
import 'package:honestore/widgets/version.dart';
import 'package:provider/provider.dart';
import 'package:honestore/constants.dart';
import 'package:share_plus/share_plus.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../services/analytics_service.dart';

final client = sb.Supabase.instance.client;

class MoreTabElement extends StatelessWidget {
  const MoreTabElement(
      {required this.title,
      this.icon,
      this.action,
      this.forUsers = false,
      Key? key})
      : super(key: key);

  final IconData? icon;
  final String title;
  final void Function()? action;
  final bool forUsers;

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      leading: icon != null ? Icon(icon) : null,
      horizontalTitleGap: 0,
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
                    try {
                      DataService.deleteUser().then((resp) {
                        client.auth.signOut();
                        context.showSnackBar(message: 'Cuenta eliminada');
                        Navigator.of(context).pop();
                        Analytics.t("Delete account");
                      });
                    } catch (error) {
                      context.showErrorSnackBar(message: error.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Eliminar')),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(32),
              child: Image.asset('assets/images/banner-inverted.png')),
          const Padding(
            padding: EdgeInsets.only(top: 5, right: 16.0, left: 16, bottom: 16),
            child: Text(
              'La comunidad para comprar de forma responsable',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // const MoreTabElement(title: 'Mi Cuenta', forUsers: true),
          MoreTabElement(
              title: 'Privacidad',
              icon: Icons.privacy_tip,
              action: openUrlCallback('https://honestore.app/privacy'),
              forUsers: false),
          MoreTabElement(
              title: 'Términos y Condiciones',
              icon: Icons.topic,
              action: openUrlCallback('https://honestore.app/terms'),
              forUsers: false),
          MoreTabElement(
              title: 'Web',
              icon: Icons.web,
              action: openUrlCallback('https://honestore.app/'),
              forUsers: false),
          MoreTabElement(
              title: 'Enviar sugerencias',
              icon: Icons.add_comment,
              action: openUrlCallback('https://honestore.app/feedback'),
              forUsers: false),
          MoreTabElement(
              title: 'Añade tu tienda',
              icon: Icons.add_business,
              action: openUrlCallback('https://honestore.app/add_shop'),
              forUsers: false),
          MoreTabElement(
              title: 'Comparte la app',
              icon: Icons.share,
              action: () {
                Share.share('https://honestore.app/download');
                Analytics.t("Share app");
              },
              forUsers: false),
          MoreTabElement(
              title: 'Eliminar Cuenta',
              icon: Icons.delete_outline,
              action: () {
                _askDeleteConfirmation(context);
              },
              forUsers: true),
          Consumer<AppState>(builder: (context, appState, child) {
            return Center(
              child: appState.user != null
                  ? ElevatedButton(
                      onPressed: () {
                        client.auth.signOut();
                        context.showSnackBar(message: "Sesión cerrada");
                        Analytics.t("Log out");
                      },
                      child: const Text('Cerrar Sesión'),
                    )
                  : Container(),
            );
          }),
          const VersionLabel()
        ],
      ),
    );
  }
}
