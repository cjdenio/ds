import 'package:flutter/material.dart';

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
  int _counter = 0;
  bool enabled = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                    modes: ["Teleoperated", "Autonomous", "Test", "Practice"],
                    selected: "Autonomous",
                  )),
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
          Expanded(child: Container(color: Colors.transparent)),
          Expanded(child: Container(color: Colors.transparent)),
          Expanded(flex: 2, child: Container(color: Colors.blue)),
        ],
      ),
    );
  }
}

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

class ModeSelector extends StatelessWidget {
  final List<String> modes;
  final String selected;

  ModeSelector({this.modes, this.selected});

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
                    print("Mode: $e");
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
