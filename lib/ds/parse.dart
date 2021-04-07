import 'dart:typed_data';

import './ds.dart';

class UdpStatusPacket {
  int seqNum;

  bool eStop;
  bool brownout;
  CodeStart codeStart;
  bool enabled;
  Mode mode;

  bool robotCode;
  bool isRoboRio;
  bool teleopCode;

  double batteryVoltage;
}

enum CodeStart { Initializing, Running }
enum UdpStatusPacketSection { Header, Status, Trace, Battery, End }

UdpStatusPacket parsePacket(Uint8List packet) {
  // print(packet);

  var currentPacket = packet.toList();
  var currentSection = UdpStatusPacketSection.Header;

  var parsedPacket = UdpStatusPacket();

  while (currentSection != UdpStatusPacketSection.End) {
    switch (currentSection) {
      case UdpStatusPacketSection.Header:
        var seqByte1 = currentPacket.removeAt(0);
        var seqByte2 = currentPacket.removeAt(0);

        parsedPacket.seqNum =
            Uint8List.fromList([seqByte2, seqByte1]).buffer.asUint16List()[0];
        currentPacket.removeAt(0);

        currentSection = UdpStatusPacketSection.Status;
        break;
      case UdpStatusPacketSection.Status:
        var statusByte = currentPacket.removeAt(0);

        parsedPacket.eStop = ((statusByte >> 7) & 1) == 1;
        parsedPacket.brownout = ((statusByte >> 4) & 1) == 1;
        parsedPacket.codeStart = ((statusByte >> 3) & 1) == 1
            ? CodeStart.Initializing
            : CodeStart.Running;
        parsedPacket.enabled = ((statusByte >> 2) & 1) == 1;

        var modeNum = statusByte & 3;
        // print(modeNum);

        switch (modeNum) {
          case 0:
            parsedPacket.mode = Mode.Teleop;
            break;
          case 1:
            parsedPacket.mode = Mode.Test;
            break;
          case 2:
            parsedPacket.mode = Mode.Autonomous;
            break;
          default:
            break;
        }
        // print("status: ${(statusByte >> 0) & 1}");

        currentSection = UdpStatusPacketSection.Trace;
        break;
      case UdpStatusPacketSection.Trace:
        var byte = currentPacket.removeAt(0);

        parsedPacket.robotCode = (byte >> 5) & 1 == 1;
        parsedPacket.isRoboRio = (byte >> 4) & 1 == 1;
        parsedPacket.teleopCode = (byte >> 1) & 1 == 1;

        currentSection = UdpStatusPacketSection.Battery;
        break;
      case UdpStatusPacketSection.Battery:
        var byte1 = currentPacket.removeAt(0);
        var byte2 = currentPacket.removeAt(1);

        parsedPacket.batteryVoltage = byte1 + byte2 / 256;

        // Discard "request date"
        currentPacket.removeAt(1);

        currentSection = UdpStatusPacketSection.End;
        break;
      default:
        break;
    }
  }

  return parsedPacket;
}
