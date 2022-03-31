import 'dart:io';

int currentStep = 0;
int numberOfFlashes = 0;

late List<List<int>> data;
void main(List<String> args) {
  File file = File('11/data.txt');
  data = file
      .readAsLinesSync()
      .map((String e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();

  print('Paso $currentStep');
  print(data);
  for (var i = 0; i < 100; i++) {
    increaseOneStep();
  }
  print(numberOfFlashes);
}

void increaseOneStep() {
  currentStep++;
  data = data
      .map((e) => e.map((e) {
            var value = e;
            value++;
            if (value > 9) {}
            return value;
          }).toList())
      .toList();
  // print('');
  // print('Paso $currentStep');
  checkForFlash();
  for (var v = 0; v < data.length; v++) {
    for (var h = 0; h < data.first.length; h++) {
      if (data[v][h] > 9) {
        data[v][h] = 0;
        numberOfFlashes++;
      }
    }
  }
}

void checkForFlash() {
  for (var v = 0; v < data.length; v++) {
    for (var h = 0; h < data.first.length; h++) {
      if (data[v][h] > 9) {
        numberOfFlashes++;
        data[v][h] = 0;
        checkAdjacentNumbers(v, h);
      }
    }
  }

  // print('');

  // print('Paso $currentStep');
  // print(data);
}

void checkAdjacentNumbers(int v, int h) {
  increaseNumber(v + 1, h);
  increaseNumber(v + 1, h + 1);
  increaseNumber(v + 1, h - 1);
  increaseNumber(v, h + 1);
  increaseNumber(v, h - 1);
  increaseNumber(v - 1, h + 1);
  increaseNumber(v - 1, h);
  increaseNumber(v - 1, h - 1);
  // print('');

  // print('Paso $currentStep');
  // print(data);
}

void increaseNumber(int v, int h) {
  if ((v >= 0) && (v < data.length) && (h >= 0) && (h < data.first.length)) {
    if (data[v][h] > 0) {
      data[v][h] = data[v][h] + 1;
      if (data[v][h] > 9) {
        numberOfFlashes++;
        data[v][h] = 0;
        checkAdjacentNumbers(v, h);
      }
    }
  }
}
