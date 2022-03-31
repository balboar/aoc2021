import 'dart:io';

void main(List<String> args) {
  File file = File('3/data.txt');
  List<String> data = file.readAsLinesSync();
  int times1 = 0;
  int times0 = 0;
  String binaryNumber = '';
  String invertedBinaryNumber = '';

  for (var i = 0; i < data[0].length; i++) {
    var value =
        data.map((x) => x[i]).map((x) => int.parse(x)).reduce((a, b) => a + b);

    times0 = 0;
    times1 = 0;
    data.forEach((element) {
      if (element[i] == '0')
        times0++;
      else
        times1++;
    });
    if (times0 > times1)
      binaryNumber += '0';
    else
      binaryNumber += '1';
  }

  invertedBinaryNumber = binaryNumber
      .replaceAll('1', '2')
      .replaceAll('0', '1')
      .replaceAll('2', '0');
  print(
      '  ${int.parse(binaryNumber, radix: 2) * int.parse(invertedBinaryNumber, radix: 2)} ');
}
