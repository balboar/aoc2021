import 'dart:io';

void main(List<String> args) {
  File file = File('7/data.txt');
  List<int> data =
      file.readAsStringSync().split(',').map((e) => int.parse(e)).toList();
  Map<int, int> fuelCost = {};

  data.sort();

  for (var i = data.first; i < data.last; i++) {
    if (!fuelCost.containsKey(i)) {
      var aux = data.fold(0, (int previousValue, element) {
        int value = (((i - element).abs() + 1) * (i - element).abs() ~/ 2);
        return value + previousValue;
      });
      fuelCost[i] = aux;
    }
  }

  List<int> results = fuelCost.values.toList();
  results.sort();
  print(results.first);
}
