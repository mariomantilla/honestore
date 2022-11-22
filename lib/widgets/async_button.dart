import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  const AsyncButton(this.label, this.action, this.success, this.error,
      {Key? key})
      : super(key: key);

  final Future Function() action;
  final Function(dynamic) success;
  final Function(dynamic) error;
  final String label;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool awaiting = false;

  makeAction() async {
    try {
      setState(() => awaiting = true);
      dynamic result = await widget.action();
      setState(() => awaiting = false);
      widget.success(result);
    } catch (error) {
      setState(() => awaiting = false);
      widget.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (!awaiting) {
            makeAction();
          }
        },
        child: awaiting
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : Text(widget.label));
  }
}
