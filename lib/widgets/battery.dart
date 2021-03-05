import 'package:flutter/material.dart';

class BatteryStatus extends StatelessWidget {
  final double status;
  final double voltage;
  static Color batteryBorder = Colors.grey[600];

  BatteryStatus({this.status = 1, this.voltage = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: batteryBorder, width: 7),
      ),
      // clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 90,
            height: 40,
          ),
          Container(
            width: 90,
            height: this.status * 40,
            color: Colors.greenAccent,
          ),
          Positioned(
            left: 5,
            top: -20,
            height: 10,
            width: 20,
            child: Container(
              decoration: BoxDecoration(
                color: batteryBorder,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: -20,
            height: 10,
            width: 20,
            child: Container(
              decoration: BoxDecoration(
                color: batteryBorder,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),
          Text(
            "$voltage V",
            style: Theme.of(context).textTheme.subtitle1.merge(
                  TextStyle(color: Colors.black),
                ),
          ),
        ],
      ),
    );
  }
}
