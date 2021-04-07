import 'package:driver_station/ds/ds.dart';
import 'package:flutter/material.dart';

class DriverStationModel extends ChangeNotifier {
  DriverStation ds;

  bool get enabled => ds.enabled;
  Mode get mode => ds.mode;

  AllianceStation get allianceStation {
    switch (ds.allianceStation) {
      case 1:
        return ds.allianceColor == AllianceColor.Red
            ? AllianceStation.Red1
            : AllianceStation.Blue1;
      case 2:
        return ds.allianceColor == AllianceColor.Red
            ? AllianceStation.Red2
            : AllianceStation.Blue2;
      case 3:
        return ds.allianceColor == AllianceColor.Red
            ? AllianceStation.Red3
            : AllianceStation.Blue3;
      default:
        return AllianceStation.Red1;
    }
  }

  DriverStationModel() {
    this.ds = DriverStation();
    this.ds.connect();
  }

  enable() {
    ds.enabled = true;
    notifyListeners();
  }

  disable() {
    ds.enabled = false;
    notifyListeners();
  }

  setMode(Mode mode) {
    ds.mode = mode;
    notifyListeners();
  }

  setAllianceStation(AllianceStation station) {
    switch (station) {
      case AllianceStation.Red1:
        ds.allianceStation = 1;
        ds.allianceColor = AllianceColor.Red;
        break;
      case AllianceStation.Red2:
        ds.allianceStation = 2;
        ds.allianceColor = AllianceColor.Red;
        break;
      case AllianceStation.Red3:
        ds.allianceStation = 3;
        ds.allianceColor = AllianceColor.Red;
        break;
      case AllianceStation.Blue1:
        ds.allianceStation = 1;
        ds.allianceColor = AllianceColor.Blue;
        break;
      case AllianceStation.Blue2:
        ds.allianceStation = 2;
        ds.allianceColor = AllianceColor.Blue;
        break;
      case AllianceStation.Blue3:
        ds.allianceStation = 3;
        ds.allianceColor = AllianceColor.Blue;
        break;
    }

    notifyListeners();
  }
}

enum AllianceStation { Red1, Red2, Red3, Blue1, Blue2, Blue3 }
