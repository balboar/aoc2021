import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  File file = File('bin/22/data.txt');
  List<Cuboid> cuboids = []; // cuboids from data file
  List<Cuboid> realCuboids =
      []; // cuboids after parsing and checking intersections

  List<List<String>> data = file
      .readAsLinesSync()
      .map((e) => e
          .replaceAll('=', ',')
          .replaceAll(' ', ',')
          .replaceAll('..', ',')
          .split(','))
      .toList();

  for (var element in data) {
    element.first = element.first == 'on' ? '1' : '-1';
    element.removeWhere((element) => element.contains(RegExp(r"[a-z]")));
  }

  cuboids = data
      .map((e) => Cuboid(int.parse(e[0]), int.parse(e[1]), int.parse(e[2]),
          int.parse(e[3]), int.parse(e[4]), int.parse(e[5]), int.parse(e[6])))
      .toList();

  for (var cuboid in cuboids) {
    if (realCuboids.isNotEmpty) {
      List<Cuboid> aux = [];
      for (var c in realCuboids) {
        {
          var intersectingCuboid = intersection(c, cuboid);
          if (intersectingCuboid != null) {
            aux.add(intersectingCuboid);
          }
        }
      }
      if ((cuboid.state == 1)) {
        aux.add(cuboid);
      }
      realCuboids.addAll(aux);
    } else {
      realCuboids.add(cuboid);
    }
  }

  int cubesOn = 0;
  for (var cuboid in realCuboids) {
    cubesOn += cuboid.state *
        ((cuboid.maxX - cuboid.minX + 1) *
            (cuboid.maxY - cuboid.minY + 1) *
            (cuboid.maxZ - cuboid.minZ + 1));
  }
  print(cubesOn);
}

dynamic intersection(Cuboid c1, Cuboid c2) {
  var c = Cuboid(
      c1.state * -1,
      max(c1.minX, c2.minX),
      min(c1.maxX, c2.maxX),
      max(c1.minY, c2.minY),
      min(c1.maxY, c2.maxY),
      max(c1.minZ, c2.minZ),
      min(c1.maxZ, c2.maxZ));
  if ((c.minX <= c.maxX) && (c.minY <= c.maxY) && (c.minZ <= c.maxZ)) {
    return c;
  }
}

class Cuboid {
  // state, 1 on, 0 off, -1 oof
  int state;
  int minX;
  int minY;
  int minZ;
  int maxX;
  int maxY;
  int maxZ;
  Cuboid(
    this.state,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
    this.minZ,
    this.maxZ,
  );

  @override
  String toString() {
    return 'Cuboid(state: $state, minX: $minX, minY: $minY, minZ: $minZ, maxX: $maxX, maxY: $maxY, maxZ: $maxZ)';
  }
}
