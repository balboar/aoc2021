import 'dart:io';

import 'dart:math';

enum PacketType { literal, operator }

late String data;
List<Packet> packets = [];
late String binaryTransmision;
int versionSum = 0;
int valueSum = 0;
void main(List<String> args) {
  File file = File('bin/16/data.txt');
  data = file.readAsStringSync();
  Transmision(data);
}

class Transmision {
  late String transmision;

  Transmision(this.transmision) {
    hexToBinary();
    parseTransmision();
  }

  void hexToBinary() {
    binaryTransmision = '';
    for (var i = 0; i < transmision.length; i++) {
      var value =
          int.parse(transmision[i], radix: 16).toRadixString(2).padLeft(4, '0');

      binaryTransmision = binaryTransmision + value;
    }
  }

  void parseTransmision() {
    while (binaryTransmision.replaceAll('0', '').isNotEmpty) {
      var packet = Packet(binaryTransmision)..parse();
    }
  }
}

class Packet {
  late int version;
  late int typeID;
  late int lengthTypeID;
  int packetLength = 0;
  String packet;
  int value = -1;
  late PacketType packetType;
  Packet(this.packet);

  int parse() {
    getVersion();
    //  print('Version $version');
    getTypeID();
    switch (packetType) {
      case PacketType.literal:
        parseLiteralTransmission();
        break;
      case PacketType.operator:
        parseOperatorTransmission();
        break;
    }

    packets.add(this);
    if (value == 10192146) {
      print(value);
    }
    print(value);
    return packetLength;
  }

  void getVersion() {
    var binary = packet.substring(0, 3);
    version = int.parse(binary, radix: 2);
    versionSum = versionSum + version;
  }

  void getTypeID() {
    var binary = packet.substring(3, 6);
    typeID = int.parse(binary, radix: 2);
    if (typeID == 4) {
      packetType = PacketType.literal;
    } else {
      packetType = PacketType.operator;
      lengthTypeID = int.parse(packet.substring(6, 7), radix: 2);
    }
  }

  void parseLiteralTransmission() {
    var data = packet.substring(6);
    var numberOfPackets = (data.length / 5).truncate();
    String binary = '';
    for (var i = 0; i < numberOfPackets; i++) {
      var currentBinary = data.substring((i * 5), (i * 5) + 5);
      binary = binary + currentBinary.substring(1, 5);
      packetLength = (i * 5) + 5;
      if (currentBinary[0] == '0') break;
    }

    packetLength = packetLength + 6;
    binaryTransmision = binaryTransmision.substring(packetLength);
    value = int.parse(binary, radix: 2);
    // print(value);
  }

  void parseOperatorTransmission() {
    if (lengthTypeID == 1) {
      parse11BitOperatorTransmission();
    } else if (lengthTypeID == 0) {
      parse15bitOperatorTransmission();
    }
  }

  void parse11BitOperatorTransmission() {
    var data = packet.substring(7, 18);
    // print(data);
    var numberOfPackets = int.parse(data, radix: 2);
    packetLength = 18;
    binaryTransmision = binaryTransmision.substring(packetLength);
    // if ((typeID == 6) || (typeID == 5) || (typeID == 7)) {
    //   print('type 5 or 6 $typeID');
    // }
    for (var i = 0; i < numberOfPackets; i++) {
      var currentPacket = Packet(binaryTransmision)..parse();
      packetLength = packetLength + currentPacket.packetLength;
      computeValue(currentPacket.value);
      // if ((typeID == 6) || (typeID == 5) || (typeID == 7)) {
      //   print(currentPacket.value);
      // }
    }
    // if ((typeID == 6) || (typeID == 5) || (typeID == 7)) {
    //   print(value);
    // }
  }

  void parse15bitOperatorTransmission() {
    var data = packet.substring(7, 22);
    var bitLengthSubPackets = int.parse(data, radix: 2);
    packetLength = 22 + bitLengthSubPackets;
    binaryTransmision = binaryTransmision.substring(22);
    int parsedLength = 0;

    while (parsedLength < bitLengthSubPackets) {
      String subPacket =
          packet.substring(parsedLength + 22, bitLengthSubPackets + 22);
      var currentPacket = Packet(subPacket)..parse();
      parsedLength = parsedLength + currentPacket.packetLength;

      computeValue(currentPacket.value);
    }
  }

  void computeValue(int newValue) {
    switch (typeID) {
      case 0:
        if (value == -1) {
          value = newValue;
        } else {
          value = value + newValue;
        }

        break;
      case 1:
        if (value == -1) {
          value = newValue;
        } else {
          value = value * newValue;
        }

        break;
      case 2:
        if (value == -1) {
          value = newValue;
        } else {
          value = min(value, newValue);
        }
        break;
      case 3:
        if (value == -1) {
          value = newValue;
        } else {
          value = max(value, newValue);
        }
        break;
      case 5:
        if (value == -1) {
          value = newValue;
        } else {
          value = value > newValue ? 1 : 0;
        }
        break;
      case 6:
        if (value == -1) {
          value = newValue;
        } else {
          value = value < newValue ? 1 : 0;
        }

        break;
      case 7:
        if (value == -1) {
          value = newValue;
        } else {
          value = newValue == value ? 1 : 0;
        }
        break;
    }
  }
}
