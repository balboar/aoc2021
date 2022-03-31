import 'dart:io';

late List<List<int>> data;
List<int> basins = [];

void main(List<String> args) {
  File file = File('9/data.txt');
  data = file
      .readAsLinesSync()
      .map((String e) =>
          e.split('').map((String element) => int.parse(element)).toList())
      .toList();

  for (var i = 0; i < data.length; i++) {
    for (var h = 0; h < data.first.length; h++) {
      basins.add(0);
      findBasin(i, h);
    }
  }
  basins.removeWhere((element) => element == 0);
  basins.sort();
  print(basins.reversed
      .toList()
      .sublist(0, 3)
      .reduce((value, element) => value * element));

  //print(points.reduce((value, element) => value + element + 1) + 1);
}

void findBasin(int vpos, int hpos) {
  if ((vpos >= 0) &&
      (vpos < data.length) &&
      (hpos >= 0) &&
      (hpos < data.first.length) &&
      (data[vpos][hpos] != 9) &&
      (data[vpos][hpos] != -1)) {
    data[vpos][hpos] = -1;
    basins[basins.length - 1]++;
    findBasin(vpos + 1, hpos);
    findBasin(vpos - 1, hpos);
    findBasin(vpos, hpos + 1);
    findBasin(vpos, hpos - 1);
  }
}
