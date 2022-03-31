import 'dart:io';

void main(List<String> args) {
  File file = File('10/data.txt');
  Map<String, int> errors = {};
  List<List<String>> data =
      file.readAsLinesSync().map((String e) => e.split('')).toList();
  Map<String, String> delimiters = {'(': ')', '[': ']', '{': '}', '<': '>'};
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
  print(errors);
  int total = 0;
  errors.forEach((key, value) {
    if (key == '}')
      total = total + value * 1197;
    else if (key == ')')
      total = total + value * 3;
    else if (key == ']')
      total = total + value * 57;
    else if (key == '>') total = total + value * 25137;
  });
  print(total);
}
