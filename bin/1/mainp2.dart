import 'dart:io';

Future<void> main(List<String> args) async {
  File file = File('1/data.txt');
  List<String> data = [];
  List<int> dataInt = [];
  List<int> dataSum = [];
  int numberOfIncreases = 0;
  data = await file.readAsLines();
  for (var element in data) {
    dataInt.add(int.parse(element));
  }
  bool firstTime = true;
  bool secondTime = false;
  int lastMeasurement = 0;
  int beforeLastMeasurement = 0;
  int thirdMeasurement = 0;
  int sum = 0;

  dataInt.forEach((element) {
    sum = sum + element - thirdMeasurement;
    if (firstTime) {
      firstTime = false;
      secondTime = true;
    } else if (secondTime) {
      secondTime = false;
    } else {
      dataSum.add(sum);
    }
    thirdMeasurement = beforeLastMeasurement;
    beforeLastMeasurement = lastMeasurement;
    lastMeasurement = element;
  });

  firstTime = true;
  dataSum.forEach((element) {
    if (firstTime)
      firstTime = false;
    else if (element > lastMeasurement) numberOfIncreases++;

    lastMeasurement = element;
  });
  print(dataSum);
  print(numberOfIncreases);
}

// 199 200 208
