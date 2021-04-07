import './ds/ds.dart';

main() async {
  var ds = DriverStation(address: "127.0.0.1");
  ds.connect();

  ds.enabled = true;
  ds.mode = Mode.Teleop;
}
