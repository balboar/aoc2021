import 'dart:io';

void main(List<String> args) {
  File file = File('10/data.txt');
  Map<String, int> errors = {};
  List<List<String>> data =
      file.readAsLinesSync().map((String e) => e.split('')).toList();
  Map<String, String> delimiters = {'(': ')', '[': ']', '{': '}', '<': '>'};
  List<List<String>> data2 = List.of(data);
  data.forEach((row) {
    List<String> chars = [];
    //  print(row);
    for (var i = 0; i < row.length; i++) {
      var element = row[i];
      if (delimiters.containsKey(element))
        chars.add(element);
      else {
        if (delimiters[chars.last] == element)
          chars.removeLast();
        else {
          data2.removeAt(data2.indexOf(row));
          if (errors.containsKey(element))
            errors.update(element, (value) => value = value + 1);
          else
            errors[element] = 1;
          break;
        }
      }
    }
    ;
  });
  int total = 0;
  List<int> result = [];
  data2.forEach((row) {
    List<String> chars = [];
    //  print(row);
    total = 0;
    for (var i = 0; i < row.length; i++) {
      var element = row[i];
      if (delimiters.containsKey(element))
        chars.add(element);
      else {
        if (delimiters[chars.last] == element) chars.removeLast();
      }
    }
    chars.reversed.forEach((element) {
      var str = delimiters[element];
      total = total * 5;
      if (str == '}')
        total = total + 3;
      else if (str == ')')
        total = total + 1;
      else if (str == ']')
        total = total + 2;
      else if (str == '>') total = total + 4;
    });
    result.add(total);
    ;
  });

  result.sort();
  print(result);
  print(result[(result.length / 2).toInt()]);
}
