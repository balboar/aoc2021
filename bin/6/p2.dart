import 'dart:io';

void main(List<String> args) {
  File file = File('6/data.txt');
  List<int> data =
      file.readAsStringSync().split(',').map((e) => int.parse(e)).toList();

  Sea sea = Sea(data);
  sea.runTime(256);
}

class Sea {
  List<Map<int, int>> days = [];
  List<int> data;
  Sea(this.data) {
    days.add({});
    data.forEach((element) {
      if (days.first.containsKey(element))
        days.first.update(element, (value) => value = value + 1);
      else
        days.first[element] = 1;
    });
  }

  void runTime(int durationInDays) {
    for (var i = 0; i < durationInDays; i++) {
      days.add({});
      days[i].forEach((key, value) {
        int aux = addOneDay(key, value);
        addDayToList(aux, amountOfDays: value);
      });
    }

    print(days.last.values.reduce((value, element) => value + element));
  }

  int addOneDay(int day, int amountOfDays) {
    day--;
    if (day == -1) {
      addDayToList(8, amountOfDays: amountOfDays);
      day = 6;
    }
    return day;
  }

  void addDayToList(int day, {int amountOfDays = 1}) {
    if (days.last.containsKey(day))
      days.last.update(day, (value) => value = value + amountOfDays);
    else
      days.last[day] = amountOfDays;
  }
}
