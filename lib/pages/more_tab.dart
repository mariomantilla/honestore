import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honestore/constants.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/widgets/tab_title.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final client = sb.Supabase.instance.client;

class MoreTab extends StatelessWidget {
  const MoreTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TabTitle('Honestore'),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                  horizontalTitleGap: 0,
                  leading: Container(
                    width: 50,
                    padding: const EdgeInsets.only(top: 8),
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(12.0),
                    child: FaIcon(
                      FontAwesomeIcons.userLarge,
                      color: CustomColors.primary,
                    ),
                  ),
                  title: Text('Mi Cuenta')),
              Consumer<AppState>(builder: (context, appState, child) {
                if (appState.user != null) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        client.auth.signOut();
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  );
                }
                return Container();
              })
            ],
          ),
        ),
      ],
    );
  }
}
