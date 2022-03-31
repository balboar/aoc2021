import 'dart:io';

Future<void> main(List<String> args) async {
  int horizontalPosition = 0;
  int verticalPosition = 0;
  List<String> data = await File('2/data.txt').readAsLines();

  List<String> forward = [];
  List<String> up = [];
  List<String> down = [];

  List<int> forwardInt = [];
  List<int> upInt = [];
  List<int> downInt = [];

  forward = List.from(data);
  up = List.from(data);
  down = List.from(data);
  forward.retainWhere((element) => element.contains('forward'));

  up.retainWhere((element) => element.contains('up'));

  down.retainWhere((element) => element.contains('down'));

  forwardInt =
      forward.map((e) => int.parse(e.replaceAll('forward', ''))).toList();

  upInt = up.map((e) => int.parse(e.replaceAll('up', ''))).toList();

  downInt = down.map((e) => int.parse(e.replaceAll('down', ''))).toList();

  for (var element in forwardInt) {
    horizontalPosition = horizontalPosition + element;
  }

  for (var element in upInt) {
    verticalPosition = verticalPosition - element;
  }

  for (var element in downInt) {
    verticalPosition = verticalPosition + element;
  }

  print(horizontalPosition * verticalPosition);
}
