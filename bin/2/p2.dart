import 'dart:io';

Future<void> main(List<String> args) async {
  int horizontalPosition = 0;
  int aim = 0;
  int depth = 0;
  List<String> data = await File('2/data.txt').readAsLines();

  data.forEach((element) {
    if (element.contains('forward')) {
      var number = int.parse(element.replaceAll('forward', ''));
      horizontalPosition = horizontalPosition + number;
      depth = depth + aim * number;
    } else if (element.contains('up')) {
      var number = int.parse(element.replaceAll('up', ''));
      aim = aim - number;
    } else if (element.contains('down')) {
      var number = int.parse(element.replaceAll('down', ''));
      aim = aim + number;
    }
    //  print('horizontal $horizontalPosition depth $depth aim $aim');
  });

  print(horizontalPosition * depth);
}
