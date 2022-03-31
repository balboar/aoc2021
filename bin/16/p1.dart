import 'dart:io';

enum PacketType { literal, operator }

late String data;
List<Packet> packets = [];
late String binaryTransmision;
int versionSum = 0;
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
      Packet(binaryTransmision).parse();
    }
    print('Version sum $versionSum');
  }
}

class Packet {
  late int version;
  late int typeID;
  late int lengthTypeID;
  int packetLength = 0;
  String packet;
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
    // print(int.parse(binary, radix: 2));
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
    for (var i = 0; i < numberOfPackets; i++) {
      var aux = Packet(binaryTransmision).parse();
      packetLength = packetLength + aux;
      //binaryTransmision = binaryTransmision.substring(aux);
      // print(data);
    }
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
      var aux = Packet(subPacket).parse();
      parsedLength = parsedLength + aux;
      // binaryTransmision = binaryTransmision.substring(aux);
    }

    //binaryTransmision = binaryTransmision.substring(bitLengthSubPackets);

    //  print('Length subpackets $bitLengthSubPackets');
  }
}
