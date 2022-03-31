import 'dart:io';

late List<List<int>> data;
late List<List<int>> matrix;
late List<String> foldData;
void main(List<String> args) {
  File file = File('13/data.txt');
  File file2 = File('13/foldata.txt');
  int maxX = 0;
  int maxY = 0;

  foldData = file2
      .readAsLinesSync()
      .map((e) => e.replaceAll('fold along ', ''))
      .toList();

  data = file
      .readAsLinesSync()
      .map((e) => e.split(',').map((e) => int.parse(e)).toList())
      .toList();

  data.forEach((element) {
    if (element.first > maxX) maxX = element.first;
    if (element.last > maxY) maxY = element.last;
  });

  matrix = List.generate(
      maxY + 1,
      (index) => List.generate(maxX + 1,
          (index) => 0)); //List.filled(maxY + 1, List.filled(maxX + 1, 0));

  data.forEach((row) {
    matrix[row.last][row.first] = 1;
  });

  foldData.forEach((element) {
    fold(element);
  });

  print(matrix);

  int value = matrix.fold(
      0,
      (previousValue, element) =>
          previousValue + element.reduce((value, element) => value + element));
  print(value);
}

void fold(String command) {
  if (command[0] == 'y') {
    int foldNumber = int.parse(command.substring(2));
    for (var i = 0; i <= foldNumber; i++) {
      for (var j = 0; j < matrix.first.length; j++) {
        // print(matrix[foldNumber + i][j]);
        if (matrix[foldNumber + i][j] == 1) matrix[foldNumber - i][j] = 1;
      }
    }

    matrix.removeRange(foldNumber, matrix.length);
  } else if (command[0] == 'x') {
    int foldNumber = int.parse(command.substring(2));
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j <= foldNumber; j++) {
        //   print(matrix[i][foldNumber + j]);
        if (matrix[i][foldNumber + j] == 1) matrix[i][foldNumber - j] = 1;
      }
    }

    matrix.forEach((element) {
      element.removeRange(foldNumber, matrix.last.length);
    });
  }
}
