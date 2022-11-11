import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  const AsyncButton(this.label, this.action, {Key? key}) : super(key: key);

  final Future Function() action;
  final String label;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool awaiting = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (!awaiting) {
            setState(() => awaiting = true);
            widget.action().then((value) => setState(() {
                  awaiting = false;
                }));
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
