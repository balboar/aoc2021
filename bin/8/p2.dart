import 'dart:io';

void main(List<String> args) {
  File file = File('8/data.txt');
  List<String> data = file.readAsLinesSync();
  List<List<String>> outputValues = [];
  int count = 0;
  data.forEach((element) {
    count = count + Display(element).outputValue();
  });
  print(count);
}

class Display {
  String input;
  List<String> patterns = [];
  List<String> outputValues = [];
  Map<int, List<String>> orderedPatterns = {};
  Map<int, String> numbers = {};
  Map<int, String> positionsOnDisplay = {};

  Display(this.input) {
    outputValues = input.split('|').last.trim().split(' ');

    patterns = input.split('|').first.trim().split(' ');
    orderNumbers();
    findUniqueNUmbers();
    findPosition0();
    findNumber6();
    findPosition1and2();
    findNumber9and0();
    findPosition3();
    findPosition4();
    findNumber2();
    findNumber3();
    findNumber5();
  }

  int outputValue() {
    String aux = '';
    outputValues.forEach((element) {
      numbers.forEach((key, value) {
        bool found = true;
        for (var i = 0; i < value.length; i++) {
          if (!element.contains(value[i])) {
            found = false;
          }
        }

        for (var i = 0; i < element.length; i++) {
          if (!value.contains(element[i])) {
            found = false;
          }
        }
        if (found) {
          aux = aux + key.toString();
        }
      });
    });

    return int.parse(aux);
  }

  void orderNumbers() {
    patterns.forEach((element) {
      if (orderedPatterns.containsKey(element.length)) {
        orderedPatterns.update(element.length, (List<String> value) {
          value.add(element);
          return value;
        });
      } else
        orderedPatterns[element.length] = [element];
    });
  }

  void findUniqueNUmbers() {
    orderedPatterns.forEach((key, value) {
      if (value.length == 1) {
        switch (key) {
          case 2:
            numbers[1] = value.first;
            break;
          case 3:
            numbers[7] = value.first;
            break;
          case 4:
            numbers[4] = value.first;
            break;
          case 7:
            numbers[8] = value.first;
            break;
        }
      }
    });
  }

  void findPosition0() {
    for (var i = 0; i < numbers[7]!.length; i++) {
      if (!numbers[1]!.contains(numbers[7]![i]))
        positionsOnDisplay[0] = numbers[7]![i];
    }
  }

  void findNumber6() {
    List<String> data = orderedPatterns[6]!;
    data.forEach((element) {
      if ((!element.contains(numbers[1]![0])) ||
          (!element.contains(numbers[1]![1]))) numbers[6] = element;
    });
  }

  void findPosition1and2() {
    if (!numbers[6]!.contains(numbers[1]![0])) {
      positionsOnDisplay[1] = numbers[1]![0];
      positionsOnDisplay[2] = numbers[1]![1];
    } else {
      positionsOnDisplay[2] = numbers[1]![0];
      positionsOnDisplay[1] = numbers[1]![1];
    }
  }

  void findNumber9and0() {
    List<String> data = orderedPatterns[6]!;
    data.forEach((element) {
      for (var i = 0; i < numbers[4]!.length; i++) {
        if ((!element.contains(numbers[4]![i])) &&
            (!numbers[1]!.contains(numbers[4]![i]))) {
          numbers[0] = element;
          positionsOnDisplay[6] = numbers[4]![i];
        }
      }
    });
    for (var i = 0; i < numbers[4]!.length; i++) {
      if (!positionsOnDisplay.values.contains(numbers[4]![i]))
        positionsOnDisplay[5] = numbers[4]![i];
    }
    numbers[9] = data.singleWhere(
        (element) => element != numbers[0] && element != numbers[6]);
  }

  void findPosition3() {
    for (var i = 0; i < numbers[9]!.length; i++) {
      if (!positionsOnDisplay.containsValue(numbers[9]![i]))
        positionsOnDisplay[3] = numbers[9]![i];
    }
  }

  void findPosition4() {
    for (var i = 0; i < numbers[0]!.length; i++) {
      if (!positionsOnDisplay.containsValue(numbers[0]![i]))
        positionsOnDisplay[4] = numbers[0]![i];
    }
  }

  void findNumber2() {
    List<String> data = orderedPatterns[5]!;
    data.forEach((element) {
      if ((!element.contains(positionsOnDisplay[5]!)) &&
          (!element.contains(positionsOnDisplay[2]!))) {
        numbers[2] = element;
      }
    });
  }

  void findNumber5() {
    List<String> data = orderedPatterns[5]!;
    data.forEach((element) {
      if ((!element.contains(positionsOnDisplay[1]!)) &&
          (!element.contains(positionsOnDisplay[4]!))) {
        numbers[5] = element;
      }
    });
  }

  void findNumber3() {
    List<String> data = orderedPatterns[5]!;
    data.forEach((element) {
      if ((!element.contains(positionsOnDisplay[5]!)) &&
          (!element.contains(positionsOnDisplay[4]!))) {
        numbers[3] = element;
      }
    });
  }
}
