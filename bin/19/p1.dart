import 'dart:io';

import 'dart:math';

const radians = [
  [1, 0, 0, 0],
  [1, pi / 2, 0, 0],
  [1, pi, 0, 0],
  [1, 3 * pi / 2, 0, 0],
  [1, 0, 0, 0],
  [1, 0, pi / 2, 0],
  [1, 0, pi, 0],
  [1, 0, 3 * pi / 2, 0],
  [1, 0, 0, 0],
  [1, 0, 0, pi / 2],
  [1, 0, 0, pi],
  [1, 0, 0, 3 * pi / 2],
  [-1, 0, 0, 0],
  [-1, pi / 2, 0, 0],
  [-1, pi, 0, 0],
  [-1, 3 * pi / 2, 0, 0],
  [-1, 0, 0, 0],
  [-1, 0, pi / 2, 0],
  [-1, 0, pi, 0],
  [-1, 0, 3 * pi / 2, 0],
  [-1, 0, 0, 0],
  [-1, 0, 0, pi / 2],
  [-1, 0, 0, pi],
  [-1, 0, 0, 3 * pi / 2]
];

const radians1 = [0, pi / 2, pi, 3 * pi / 2];

late List<String> input;
List<Scanner> scanners = [];
Set<Beacon> commonBeacons = {};
Map<int, dynamic> postionsScanners = {};
int count = 0;
bool found = false;
void main(List<String> args) {
  File file = File('bin/19/data.txt');
  input = file.readAsLinesSync();
  for (var line in input) {
    if (line.startsWith('---')) {
      scanners.add(Scanner());
    } else if (line.isNotEmpty) {
      scanners.last.add(Beacon.fromString(line));
    }
  }

  commonBeacons.addAll(scanners.first.beacons);

  for (var mainScannerIndex = 0;
      mainScannerIndex < scanners.length;
      mainScannerIndex++) {
    var mainScanner = scanners[mainScannerIndex];
    var mainBeacons = mainScanner.beacons;

    for (var indexMainBeacons = 0;
        indexMainBeacons < mainBeacons.length;
        indexMainBeacons++) {
      count = 0;
      List<Beacon> distancesMainScanner = mainScanner.computeDistances(
          mainBeacons[indexMainBeacons], mainBeacons);
      for (var scannerIndex = 0;
          scannerIndex < scanners.length;
          scannerIndex++) {
        if (scannerIndex > mainScannerIndex) {
          var secondaryScanner = scanners[scannerIndex];
          secondaryScanner.rotateBeacons();
          for (var item in secondaryScanner.rotatedBeacons) {
            print(item.first);
          }
          found = false;
          for (var indexRotatedBeacons = 0;
              indexRotatedBeacons < secondaryScanner.rotatedBeacons.length &&
                  !found;
              indexRotatedBeacons++) {
            count = 0;

            var secondaryBeacons =
                secondaryScanner.rotatedBeacons[indexRotatedBeacons];
            for (var indexSecondaryBeacons = 0;
                indexSecondaryBeacons < secondaryBeacons.length;
                indexSecondaryBeacons++) {
              count = 0;
              if ((secondaryBeacons[indexSecondaryBeacons].x == -479) &&
                  (secondaryBeacons[indexSecondaryBeacons].y == 426))
                print(found);
              List<Beacon> distancesSecondaryScanner =
                  secondaryScanner.computeDistances(
                      secondaryBeacons[indexSecondaryBeacons],
                      secondaryBeacons);
              List<Beacon> overlappingBeacons = [];
              for (var beacon in distancesSecondaryScanner) {
                if (distancesMainScanner.contains(beacon)) {
                  count++;
                  overlappingBeacons.add(beacon);
                }
              }
              var relativeBeacon;

              if (count == 12) {
                print(count);
                found = true;
                print(
                    'main scanner $mainScannerIndex  secondary scanner $scannerIndex');
                print(indexRotatedBeacons);
                for (var beacon in overlappingBeacons) {
                  var original = distancesMainScanner
                      .firstWhere((element) => element == beacon);
                  // print(original.originalBeacon);
                  commonBeacons.add(original.originalBeacon!);
                  relativeBeacon = distanceBetweenBeacons(
                      original.originalBeacon!, beacon.originalBeacon!);
                  if (mainScannerIndex != 0) {
                    relativeBeacon = distanceBetweenBeacons(
                        postionsScanners[mainScannerIndex], relativeBeacon);
                  }
                  postionsScanners[scannerIndex] = relativeBeacon;

                  print(relativeBeacon);
                  // print(beacon.originalBeacon!.originalBeacon!);
                }

                var beacon = distancesSecondaryScanner.first;

                for (var beacon in secondaryBeacons) {
                  commonBeacons.add(returnBeaconPositionFormDistanceBeacons(
                      relativeBeacon, beacon));
                }

                for (var beacon in distancesSecondaryScanner) {
                  print(distanceBetweenBeacons(
                      beacon.originalBeacon!.originalBeacon!, beacon.origin!));
                }
                break;
              }
            }
          }
        }
      }
    }
  }

  print(commonBeacons.length);
}

Beacon distanceBetweenBeacons(Beacon first, Beacon second) {
  return Beacon(first.x - second.x, first.y - second.y, first.z - second.z,
      originalBeacon: second, origin: first);
}

Beacon returnBeaconPositionFormDistanceBeacons(Beacon first, Beacon second) {
  return Beacon(first.x + second.x, first.y + second.y, first.z + second.z);
}

class Scanner {
  List<Beacon> beacons = [];
  List<Beacon> beaconsOriginal = [];
  List<List<Beacon>> rotatedBeacons = [];

  void add(Beacon beacon) {
    beacons.add(beacon);
    beaconsOriginal.add(beacon);
  }

  List<Beacon> computeDistances(Beacon reference, List<Beacon> beacons) {
    List<Beacon> list = [];

    for (var i = 0; i < beacons.length; i++) {
      list.add(distanceBetweenBeacons(reference, beacons[i]));
    }
    return list;
  }

  Beacon rotatePoint(
      Beacon point, num roll, num pitch, num yaw, Beacon original) {
    int x = ((cos(yaw) * cos(pitch) * point.x) +
            (((cos(yaw) * sin(pitch) * sin(roll)) - (sin(yaw) * cos(roll))) *
                point.y) +
            (((cos(yaw) * sin(pitch) * cos(roll)) + (sin(yaw) * sin(roll))) *
                point.z))
        .round();
    int y = ((sin(yaw) * cos(pitch) * point.x) +
            (((sin(yaw) * sin(pitch) * sin(roll)) + (cos(yaw) * cos(roll))) *
                point.y) +
            (((sin(yaw) * sin(pitch) * cos(roll)) - (cos(yaw) * sin(roll))) *
                point.z))
        .round();
    int z = ((-sin(pitch) * point.x) +
            (cos(pitch) * sin(roll) * point.y) +
            (cos(pitch) * cos(roll) * point.z))
        .round();
    return Beacon(x, y, z, originalBeacon: original);
  }

  // void rotateBeacons() {
  //   rotatedBeacons.clear();
  //   for (var rad in radians) {
  //     rotatedBeacons.add([]);
  //     for (var point in beacons) {
  //       rotatedBeacons.last.add(rotatePoint(
  //           Beacon(point.x * rad[0].round(), point.y * rad[0].round(),
  //               point.z * rad[0].round()),
  //           rad[1],
  //           rad[2],
  //           rad[3],
  //           point));
  //     }
  //   }
  // }

  void rotateBeacons() {
    rotatedBeacons.clear();
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.x, p.y, p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.x, p.z, -p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.x, -p.y, -p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.x, -p.z, p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.x, -p.y, p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.x, p.z, p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.x, p.y, -p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.x, -p.z, -p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.y, -p.x, p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.y, p.z, p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.y, p.x, -p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.y, -p.z, -p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.y, p.x, p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.y, p.z, -p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.y, -p.z, p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.y, -p.x, -p.z, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.z, p.y, -p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.z, -p.x, -p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.z, -p.y, p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(p.z, p.x, p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.z, p.y, p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.z, p.x, -p.y, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.z, -p.y, -p.x, originalBeacon: p));
    }
    rotatedBeacons.add([]);
    for (var p in beacons) {
      rotatedBeacons.last.add(Beacon(-p.z, -p.x, p.y, originalBeacon: p));
    }
  }

  Beacon rotateBeaconBack(int index, Beacon point) {
    var rad = radians[index];

    return rotatePoint(
        Beacon(point.x * rad[0].round(), point.y * rad[0].round(),
            point.z * rad[0].round()),
        -rad[1],
        -rad[2],
        -rad[3],
        point);
  }
}

class Beacon {
  int x = 0;
  int y = 0;
  int z = 0;
  num roll = 0;
  num yaw = 0;
  num pitch = 0;
  Beacon? originalBeacon;
  Beacon? origin;
  Beacon(this.x, this.y, this.z,
      {this.roll = 0,
      this.pitch = 0,
      this.yaw = 0,
      this.originalBeacon,
      this.origin});

  Beacon.fromString(String beacon) {
    List<int> positions = beacon.split(',').map((e) => int.parse(e)).toList();
    x = positions[0];
    y = positions[1];
    z = positions[2];
  }

  @override
  bool operator ==(Object other) {
    if (other is Beacon) {
      return ((x == other.x) && (y == other.y) && (z == other.z));
    }
    return false;
  }

  @override
  String toString() {
    return 'Beacon x: $x y: $y z: $z';
  }

  @override
  int get hashCode => x * y * z;
}
