import 'dart:io';

late List<String> input;
late String data;
RegExp findPair = RegExp(r'(\[\d\d*,\d\d*\])');
RegExp findPrecedingNumber = RegExp(r',?\d\d*,?(?=[^\d,])');
RegExp findTrailingNumber = RegExp(r'((?<=[^\d,]),?\d\d*,?)');
RegExp findRegularNumber = RegExp(r'((?<=,?)\d\d\d*(?=,?))');

void main(List<String> args) {
  File file = File('bin/18/testdata2.txt');
  input = file.readAsLinesSync();
  data = input[0];
  for (var i = 1; i < input.length; i++) {
    data = '[' + data + ',' + input[i] + ']';
    //  print('');
    //   print(data);
    process();
    //  print(data);
  }

  while (findPair.allMatches(data).length > 0) {
    sumPairs();
    print('');
    print(data);
  }
}

void process() {
  bool canProcess = true;
  while (canProcess) {
    canProcess = findFirstPair();
    if (!canProcess) {
      canProcess = findFirstNumber();
    }
  }
}

int splitPair(int index, RegExpMatch pair, RegExpMatch? firstNumber,
    RegExpMatch? secondNumber) {
  var numbersInPair = pair.group(0)!.split(',');
  int number = 0;
  if (secondNumber != null) {
    number = int.parse(data
        .substring(
            pair.end - 1 + secondNumber.start, pair.end - 1 + secondNumber.end)
        .replaceAll(RegExp(r'[\[\]\,]'), ''));

    var secondNumberInPair =
        int.parse(numbersInPair.last.replaceAll(RegExp(r'[\[\]\,]'), ''));
    var result = number + secondNumberInPair;
    data = data.replaceFirst(number.toString(), result.toString(),
        secondNumber.start + pair.end - 1);
  }
  number = 0;
  if (firstNumber != null) {
    number = int.parse(data
        .substring(firstNumber.start, firstNumber.end)
        .replaceAll(RegExp(r'[\[\]\,]'), ''));
  }
  data = data.replaceFirst(pair.group(0)!, '0', pair.start);
  if (firstNumber != null) {
    var firstNumberInPair = int.parse(numbersInPair.first
        .replaceAll(RegExp(r'[\[\]\,]'), '')
        .replaceAll(RegExp(r'[\[\]\,]'), ''));
    var result = number + firstNumberInPair;
    data = data.replaceFirst(
        number.toString(), result.toString(), firstNumber.start);
  }

  return 0;
}

bool findFirstPair() {
  int numberOfOpening = 0;
  Iterable<RegExpMatch> match = [];
  Iterable<RegExpMatch> matchPrecedingNumber = [];
  Iterable<RegExpMatch> matchTrailingNumber = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i] == '[') {
      numberOfOpening++;
    } else if (data[i] == ']') {
      numberOfOpening--;
    }
    if (numberOfOpening == 5) {
      match = findPair.allMatches(data, i);

      if (match.isNotEmpty) {
        matchPrecedingNumber = findPrecedingNumber
            .allMatches(data.substring(0, match.first.start + 1));
        matchTrailingNumber =
            findTrailingNumber.allMatches(data.substring(match.first.end - 1));
        splitPair(
            i,
            match.first,
            matchPrecedingNumber.isNotEmpty ? matchPrecedingNumber.last : null,
            matchTrailingNumber.isNotEmpty ? matchTrailingNumber.first : null);

        break;
      }
    }
  }
  return match.isNotEmpty;
}

bool findFirstNumber() {
  RegExpMatch? match = findRegularNumber.firstMatch(data);
  int number = 0;
  if (match != null) {
    number = int.parse(match.group(0)!);

    String newPair = '[${(number / 2).floor()},${(number / 2).ceil()}]';
    data = data.replaceFirst(number.toString(), newPair, match.start);
  }
  return match != null;
}

void sumPairs() {
  Iterable<RegExpMatch> match = findPair.allMatches(data);
  match.toList().reversed.forEach((element) {
    String str =
        element.group(0)!.replaceAllMapped(RegExp(r'\[?\]?'), (match) => '');
    List<int> pair = str.split(',').map((e) => int.parse(e)).toList();

    int result = pair[0] * 3 + pair[1] * 2;
    data = data.replaceAll(element.group(0)!, result.toString());
  });
}
