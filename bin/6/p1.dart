import 'dart:io';

void main(List<String> args) {
  File file = File('6/data.txt');
  List<int> data =
      file.readAsStringSync().split(',').map((e) => int.parse(e)).toList();
  List<List<int>> days = [];

  days.add([]);
  days.first.addAll(data);

  for (var i = 0; i < 80; i++) {
    days.add([]);
    days[i].forEach((element) {
      days.last.add(addOneDay(days, element));
    });
  }

  print(days.last.length);
}

int addOneDay(List<List<int>> days, int day) {
  var internalTimer = day;
  internalTimer--;
  if (internalTimer == -1) {
    days.last.add(8);
    internalTimer = 6;
  }
  return internalTimer;
}
