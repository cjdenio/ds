import 'package:driver_station/widgets/battery.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async' show Timer;
import 'dart:typed_data';

import './widgets/enabledisable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool enabled = false;
  String mode = "Teleoperated";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ModeSelector(
                      modes: ["Teleoperated", "Autonomous", "Test"],
                      selected: this.mode,
                      onChange: (mode) {
                        setState(() {
                          this.mode = mode;
                          if (enabled) {
                            this.enabled = false;
                          }
                        });
                      },
                    ),
                  ),
                  EnableDisable(
                    enabled: this.enabled,
                    onChange: (enabled) {
                      setState(() {
                        this.enabled = enabled;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text("Elapsed Time"),
                      ),
                      Text(
                        "0:00.00",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: BatteryStatus(
                      status: 0.8,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Status(text: "Communications", success: true),
                  Status(text: "Robot Code", success: true),
                  Status(text: "Joysticks"),
                ],
              ),
            ),
          ),
          Expanded(flex: 2, child: Container(color: Colors.blue)),
        ],
      ),
    );
  }
}

class Status extends StatelessWidget {
  final String text;
  final bool success;

  Status({this.text, this.success = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.only(right: 10), child: Text(this.text)),
          Expanded(child: Container()),
          Icon(
            Icons.circle,
            color: this.success ? Colors.greenAccent : Colors.red,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class ModeSelector extends StatelessWidget {
  final List<String> modes;
  final String selected;
  final void Function(String) onChange;

  ModeSelector({this.modes, this.selected, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: this
            .modes
            .map(
              (e) => Material(
                color: e == this.selected ? Colors.blue : null,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onTap: () {
                    this.onChange(e);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
