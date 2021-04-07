import 'dart:io';
import 'dart:async';

import './parse.dart';

class DriverStation {
  final String address;

  RawDatagramSocket udpSocket;
  Socket tcpSocket;

  bool enabled = false;
  Mode mode = Mode.Teleop;

  AllianceColor allianceColor = AllianceColor.Red;
  int allianceStation = 1;

  double batteryVoltage = 0;

  DriverStation({this.address = "127.0.0.1"});

  connect() async {
    // try {
    //   var results = await Future.wait([
    //     RawDatagramSocket.bind("0.0.0.0", 1150),
    //     Socket.connect(this.address, 1740)
    //   ]);
    //   this.udpSocket = results[0] as RawDatagramSocket;
    //   this.tcpSocket = results[1] as Socket;

    //   this._startUdpSender();
    // } catch (e) {}
  }

  _startUdpSender() {
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      this.udpSocket?.send([
        /* sequence */ 0x00,
        /*        > */ 0x00,
        /* version */ 0x01,
        /* control */ _buildControlPacket(
          mode: this.mode,
          enabled: this.enabled,
        ),
        /* request */ _buildRequestPacket(),
        /* alliance */ _buildAlliance(
          color: this.allianceColor,
          station: this.allianceStation,
        )
      ], InternetAddress(this.address), 1110);

      var receivedPacket = this.udpSocket.receive();
      if (receivedPacket != null) {
        var parsedPacket = parsePacket(receivedPacket.data);

        this.batteryVoltage = parsedPacket.batteryVoltage;
      }
    });
  }

  int _buildControlPacket({
    bool eStop = false,
    bool fms = false,
    bool enabled = false,
    Mode mode = Mode.Teleop,
  }) {
    int num = 0;

    if (eStop) num += 128;
    if (fms) num += 8;
    if (enabled) num += 4;

    switch (mode) {
      case Mode.Test:
        num += 1;
        break;
      case Mode.Autonomous:
        num += 2;
        break;
      default:
    }

    return num;
  }

  int _buildRequestPacket({bool reboot = false, bool restart = false}) {
    var num = 0;

    if (reboot) num += 8;
    if (restart) num += 4;

    return num;
  }

  int _buildAlliance(
      {AllianceColor color = AllianceColor.Red, int station = 1}) {
    assert(station >= 1 && station <= 3);

    if (color == AllianceColor.Red) {
      return station - 1;
    } else {
      return station + 2;
    }
  }
}

enum Mode { Teleop, Test, Autonomous }
enum AllianceColor { Red, Blue }

String modeToString(Mode mode) {
  switch (mode) {
    case Mode.Autonomous:
      return "Autonomous";
    case Mode.Teleop:
      return "Teleoperated";
    case Mode.Test:
      return "Test";
  }
}
