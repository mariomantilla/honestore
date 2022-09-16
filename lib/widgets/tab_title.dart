import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  const TabTitle(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Divider(),
        )
      ],
    );
  }
}
