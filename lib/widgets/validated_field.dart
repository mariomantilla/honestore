import 'package:flutter/material.dart';

class ValidatedField extends StatefulWidget {
  const ValidatedField(
      {this.label,
      this.icon,
      this.password = false,
      this.validation,
      this.controller,
      Key? key})
      : super(key: key);

  final TextEditingController? controller;
  final String? label;
  final IconData? icon;
  final bool password;
  final Function? validation;

  @override
  State<ValidatedField> createState() => _ValidatedFieldState();
}

class _ValidatedFieldState extends State<ValidatedField> {
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        hintText: 'Email',
        errorText: _emailErrorText,
        prefixIcon: Icon(widget.icon),
      ),
      onChanged: (value) {
        if (widget.validation != null) {
          String? text = widget.validation!(value);
          setState(() {
            _emailErrorText = text;
          });
        }
      },
      obscureText: widget.password,
      enableSuggestions: !widget.password,
      autocorrect: !widget.password,
    );
  }
}
