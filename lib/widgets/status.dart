import "package:flutter/material.dart";

enum Status { Success, Fail, Warning }

class StatusItem {
  final String text;
  final Status status;

  StatusItem({this.text, this.status = Status.Fail});
}

Color _statusToColor(Status status) {
  switch (status) {
    case Status.Success:
      return Colors.greenAccent;
    case Status.Fail:
      return Colors.red;
    case Status.Warning:
      return Colors.yellow;
    default:
      return Colors.black;
  }
}

class Statuses extends StatelessWidget {
  final List<StatusItem> items;

  Statuses({this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        children: [
          for (var item in items)
            Row(
              children: [
                Text(item.text),
                Icon(
                  Icons.circle,
                  color: _statusToColor(item.status),
                  size: 15,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
        ]
            .map((i) =>
                Container(child: i, margin: EdgeInsets.symmetric(vertical: 2)))
            .toList(),
      ),
    );
  }
}
