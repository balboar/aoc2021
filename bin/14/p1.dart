import 'dart:io';

import 'dart:math';

int currentStep = 0;
int numberOfFlashes = 0;

late List<String> data;
late List<List<String>> insertionRules = [];
late List<String> templates = [];
late Map<String, dynamic> elements = {};
void main(List<String> args) {
  File file = File('bin/14/data.txt');
  data = file.readAsLinesSync();

  templates.add(data.first);

  data.removeRange(0, 2);
  insertionRules = data.map((e) => e.split('->')).toList();

  for (var i = 0; i < 10; i++) {
    increaseStep(templates.last);
  }

  for (var i = 0; i < templates.last.length; i++) {
    if (elements.containsKey(templates.last.substring(i, i + 1))) {
      elements.update(
          templates.last.substring(i, i + 1), (value) => value = value + 1);
    } else
      elements[templates.last.substring(i, i + 1)] = 1;
  }

  print(elements);
  var values = elements.values.toList();
  values.sort();
  print(values.last - values.first);
}

void increaseStep(String template) {
  String newTemplate = template.substring(0, 1);
  for (var i = 0; i < template.length - 1; i++) {
    String pair = template.substring(i, i + 2);
    var element = insertionRules.firstWhere((element) {
      return element.first.trim() == pair;
    });

    newTemplate = newTemplate + element.last.trim() + pair.substring(1);
  }
  templates.add(newTemplate);
}
