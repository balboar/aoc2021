import 'dart:io';

import 'dart:math';

int currentStep = 0;
int numberOfFlashes = 0;

late List<String> data;
late List<List<String>> insertionRules = [];
late List<Map<String, dynamic>> templates = [];
late Map<String, dynamic> elements = {};
void main(List<String> args) {
  File file = File('14/data.txt');
  data = file.readAsLinesSync();
  initTemplates();
  data.removeRange(0, 2);
  insertionRules = data.map((e) => e.split('->')).toList();

  for (var i = 0; i < 40; i++) {
    increaseStep(i);
  }

  elements[templates.last.keys.first.substring(0, 0 + 1)] =
      templates.last.values.first;

  templates.last.forEach((key, previous) {
    if (elements.containsKey(key.substring(1))) {
      elements.update(key.substring(1), (value) => value = value + previous);
    } else
      elements[key.substring(1)] = previous;
  });

  print(elements);
  var values = elements.values.toList();
  values.sort();
  print(values.last - values.first);
}

void initTemplates() {
  templates.add({});
  for (var i = 0; i < data.first.length - 1; i++) {
    String pair = data.first.substring(i, i + 2);
    if (templates.first.containsKey(pair)) {
      templates.first.update(pair, (value) => value = value + 1);
    } else
      templates.first[pair] = 1;
  }
}

void increaseStep(int index) {
  templates.add({});
  templates[index].forEach((key, value) {
    var element = insertionRules.firstWhere((element) {
      return element.first.trim() == key;
    });
    String firstElement = key.split('').first + element.last.trim();
    String secondElement = element.last.trim() + key.split('').last;

    addElementToTemplates(index, firstElement, value);
    addElementToTemplates(index, secondElement, value);
    // addElementToTemplates(index, key, -value);
  });
}

void addElementToTemplates(int index, String element, int currentValue) {
  if (templates.last.containsKey(element)) {
    templates.last.update(element, (value) {
      var val = value + currentValue;
      if (val < 0) val = 0;
      return val;
    });
  } else if (currentValue > 0) templates.last[element] = currentValue;
}
