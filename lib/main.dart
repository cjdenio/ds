import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';

import 'package:driver_station/ds/ds.dart';

import 'package:driver_station/models/ds.dart';

import 'package:driver_station/widgets/battery.dart';
import 'package:driver_station/widgets/status.dart';

import 'package:flutter/material.dart';

import './widgets/enabledisable.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DesktopWindow.setWindowSize(Size(1000, 230));
  DesktopWindow.setMaxWindowSize(Size(1500, 230));
  DesktopWindow.setMinWindowSize(Size(900, 230));

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
      home: ChangeNotifierProvider(
        create: (context) => DriverStationModel(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
          Container(
            padding: EdgeInsets.only(bottom: 10),
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Consumer<DriverStationModel>(
                    builder: (ctx, ds, child) => ModeSelector(
                      modes: ["Teleoperated", "Autonomous", "Test"],
                      selected: modeToString(ds.mode),
                      onChange: (mode) {
                        // disable if necessary
                        if (ds.enabled) {
                          ds.disable();
                        }

                        switch (mode) {
                          case "Teleoperated":
                            ds.setMode(Mode.Teleop);
                            break;
                          case "Autonomous":
                            ds.setMode(Mode.Autonomous);
                            break;
                          case "Test":
                            ds.setMode(Mode.Test);
                            break;
                        }
                      },
                    ),
                  ),
                ),
                Consumer<DriverStationModel>(builder: (context, ds, child) {
                  return EnableDisable(
                    enabled: ds.enabled,
                    onChange: (enabled) {
                      if (enabled) {
                        ds.enable();
                      } else {
                        ds.disable();
                      }
                    },
                  );
                })
              ],
            ),
          ),
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text("Elapsed Time"),
                    ),
                    Text("0:00.00",
                        // style: Theme.of(context).textTheme.headline4,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Consumer<DriverStationModel>(
                      builder: (context, ds, child) => Text.rich(
                        TextSpan(
                          text: modeToString(ds.mode) + "\n",
                          children: [
                            TextSpan(
                              text: ds.enabled ? 'Enabled' : 'Disabled',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ds.enabled ? Colors.redAccent : null),
                            )
                          ],
                        ),
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Consumer<DriverStationModel>(
                  builder: (context, ds, child) =>
                      DropdownButton<AllianceStation>(
                    onChanged: (i) {
                      ds.setAllianceStation(i);
                    },
                    value: ds.allianceStation,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                          child: Text("Red 1"), value: AllianceStation.Red1),
                      DropdownMenuItem(
                          child: Text("Red 2"), value: AllianceStation.Red2),
                      DropdownMenuItem(
                          child: Text("Red 3"), value: AllianceStation.Red3),
                      DropdownMenuItem(
                          child: Text("Blue 1"), value: AllianceStation.Blue1),
                      DropdownMenuItem(
                          child: Text("Blue 2"), value: AllianceStation.Blue2),
                      DropdownMenuItem(
                          child: Text("Blue 3"), value: AllianceStation.Blue3),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Consumer<DriverStationModel>(
                    builder: (context, ds, child) => BatteryStatus(
                      voltage: 12,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                Statuses(
                  items: [
                    StatusItem(text: "Communications", status: Status.Warning),
                    StatusItem(text: "Robot Code", status: Status.Success),
                    StatusItem(text: "Joysticks", status: Status.Fail),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.all(10),
              height: double.infinity,
              child: Text("logs logs logs logs blah"),
            ),
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
