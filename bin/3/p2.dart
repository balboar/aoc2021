import 'dart:io';

void main(List<String> args) {
  File file = File('3/data.txt');
  List<String> data = file.readAsLinesSync();
  int times1 = 0;
  int times0 = 0;
  String binaryNumber = '';
  String invertedBinaryNumber = '';
  List<String> data2 = List.from(data);

  for (var i = 0; i < data[0].length; i++) {
    times0 = 0;
    times1 = 0;
    data.forEach((element) {
      if (element[i] == '0')
        times0++;
      else
        times1++;
    });
    if (times0 > times1)
      data.removeWhere((element) => element[i] == '0');
    else
      data.removeWhere((element) => element[i] == '1');

    if (data.length == 1) break;
  }

  for (var i = 0; i < data2[0].length; i++) {
    times0 = 0;
    times1 = 0;
    data2.forEach((element) {
      if (element[i] == '0')
        times0++;
      else
        times1++;
    });
    if (times0 > times1)
      data2.removeWhere((element) => element[i] == '1');
    else
      data2.removeWhere((element) => element[i] == '0');

    if (data2.length == 1) break;
  }

  print(data[0]);
  print(data2[0]);

  print('  ${int.parse(data[0], radix: 2) * int.parse(data2[0], radix: 2)} ');
}
