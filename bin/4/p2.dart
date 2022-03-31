import 'dart:io';

Future<void> main(List<String> args) async {
  File file = File('4/data.txt');
  List<String> data1 = await file.readAsLines();
  List<List<List<String>>> data2 = [];
  List<List<List<int>>> data = [];
  List<int> numbers = data1.first.split(",").map((e) => int.parse(e)).toList();

  data1.skip(1).forEach((element) {
    if (element.isEmpty)
      data2.add([]);
    else
      data2.last.add(element.split(" "));
  });
  data2.forEach((list1) {
    list1.forEach((list2) {
      list2.removeWhere((element) => element == "");
    });
  });

  data2.forEach((list1) {
    data.add([]);
    list1.forEach((list2) {
      data.last.add(list2.map((e) => int.parse(e)).toList());
    });
  });

  for (var i = 0; i < numbers.length; i++) {
    buscarNumero(data, numbers[i]);
    // print(numbers[i]);
    // print(data);

    var bingo = comprobarBingo(data);
    print('');
    print('number ${numbers[i]}');
    print(data);

    if (bingo.length > 0) {
      print('bingo $bingo');
      print('data length ${data.length}');
      if (data.length > 1)
        bingo.reversed.forEach((element) {
          print('delete $element');

          data.removeAt(element);
        });
      else {
        print('');
        print('');
        var result = data.first
            .map((e) => e.reduce((value, element) {
                  element = element == -1 ? 0 : element;
                  value = value == -1 ? 0 : value;

                  return element + value;
                }))
            .toList();

        var result2 = result.reduce((value, element) {
          element = element == -1 ? 0 : element;
          value = value == -1 ? 0 : value;

          return element + value;
        });

        print(result2);
        print(result2 * numbers[i]);
        print(data.length);

        exit(0);
      }
    }
  }
}

void buscarNumero(List<List<List<int>>> data, int number) {
  for (var iboard = 0; iboard < data.length; iboard++) {
    for (var il2 = 0; il2 < data[iboard].length; il2++) {
      for (var il3 = 0; il3 < data[iboard][il2].length; il3++) {
        var numb = data[iboard][il2][il3];
        if (numb == number) data[iboard][il2][il3] = -1;
      }
    }
  }
}

List<int> comprobarBingo(List<List<List<int>>> data) {
  bool exitLoop = false;
  List<int> result = [];

  for (var iboard = 0; iboard < data.length; iboard++) {
    if (exitLoop) break;
    for (var il2 = 0; il2 < data[iboard].length; il2++) {
      // print(data[iboard][il2]);
      if (exitLoop) break;
      var value1 =
          data[iboard][il2].reduce((value, element) => value + element);
      //  print(value1);
      if (value1 == -5) {
        {
          if (!result.contains(iboard)) result.add(iboard);

          ///   print(result);

        }
      }
    }
  }

  if (!exitLoop) {
    for (var iboard = 0; iboard < data.length; iboard++) {
      if (exitLoop) break;

      for (var il2 = 0; il2 < data[iboard].first.length; il2++) {
        if (exitLoop) break;

        var columnas = data[iboard].length;
        var value = 0;
        for (var j = 0; j < data[iboard].length; j++) {
          value += data[iboard][j][il2];
        }

        if (value == -5) {
          {
            print('bingo $iboard');
            if (!result.contains(iboard)) result.add(iboard);

            ///   print(result);

          }
        }

        // print(data[iboard][il2]);

      }
    }
  }
  return result;
}
