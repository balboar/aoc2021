import 'dart:io';

Future<void> main(List<String> args) async {
  File file = File('1/data.txt');
  List<String> data = [];
  List<int> dataInt = [];
  int numberOfIncreases = 0;
  data = await file.readAsLines();
  data.forEach((element) {
    dataInt.add(int.parse(element));
  });
  bool firstTime = true;
  int previosMeasurement = 0;

  dataInt.forEach((element) {
    if (firstTime)
      firstTime = false;
    else if (element > previosMeasurement) numberOfIncreases++;

    previosMeasurement = element;
  });
  print(numberOfIncreases);
}
