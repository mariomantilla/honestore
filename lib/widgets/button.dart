import 'package:flutter/material.dart';
import 'package:honestore/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {Key? key, required this.pressedCallback, this.text, this.icon})
      : super(key: key);

  final GestureTapCallback pressedCallback;
  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [];

    if (text != null) {
      elements.add(Text(text!));
    }
    if (icon != null) {
      if (elements.isNotEmpty) {
        elements.add(const Padding(padding: EdgeInsets.only(left: 5)));
      }
      elements.add(Icon(icon));
    }

    return OutlinedButton(
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(CustomColors.primary)),
        onPressed: pressedCallback,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: elements,
        ));
  }
}
