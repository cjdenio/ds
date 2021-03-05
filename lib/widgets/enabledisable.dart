import 'package:flutter/material.dart';

class EnableDisable extends StatelessWidget {
  final bool enabled;
  final void Function(bool) onChange;

  EnableDisable({this.enabled = false, this.onChange});

  Widget getButton(String text, Color color, bool selected) {
    return selected
        ? ElevatedButton(
            onPressed: () {
              this.onChange(text == "Enable");
            },
            child: Text(text),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(30)),
              backgroundColor: MaterialStateProperty.all(color),
            ),
          )
        : OutlinedButton(
            onPressed: () {
              this.onChange(text == "Enable");
            },
            child: Text(text),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(30)),
                foregroundColor: MaterialStateProperty.all(color)),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: getButton("Enable", Colors.blue, this.enabled),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: getButton("Disable", Colors.red, !this.enabled),
        ),
      ],
    );
  }
}
