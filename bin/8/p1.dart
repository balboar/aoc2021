import 'dart:io';

void main(List<String> args) {
  File file = File('8/data.txt');
  List<String> data = file.readAsLinesSync();
  List<List<String>> outputValues = [];
  int count = 0;
  data.forEach((element) {
    outputValues.add(element.split('|').last.trim().split(' '));
  });

  outputValues.forEach((row) {
    row.removeWhere(
        (value) => value.length < 2 || (value.length > 4 && value.length != 7));
  });

  outputValues.forEach((element) {
    count = count + element.length;
  });
  print(count);
}
