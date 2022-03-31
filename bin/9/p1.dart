import 'dart:io';

void main(List<String> args) {
  File file = File('9/data.txt');
  List<int> points = [];
  List<List<int>> data = file
      .readAsLinesSync()
      .map((String e) =>
          e.split('').map((String element) => int.parse(element)).toList())
      .toList();

  int maxVerticalLength = data.length;
  int maxHorizontalLenth = data.first.length;
  int number = 0;
  bool lowPoint = true;
  for (var v = 0; v < maxVerticalLength; v++) {
    for (var h = 0; h < maxHorizontalLenth; h++) {
      //  print('h=$h, v=$v');
      number = data[v][h];
      lowPoint = true;
      if (v - 1 >= 0) {
        if (data[v - 1][h] <= number) lowPoint = false;
      }
      if (v + 1 < maxVerticalLength) {
        if (data[v + 1][h] <= number) lowPoint = false;
      }
      if (h - 1 >= 0) {
        if (data[v][h - 1] <= number) lowPoint = false;
      }
      if (h + 1 < maxHorizontalLenth) {
        if (data[v][h + 1] <= number) lowPoint = false;
      }
      if (lowPoint) points.add(number);
    }
  }
  print(points.reduce((value, element) => value + element + 1) + 1);
}
