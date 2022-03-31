import 'dart:io';

Future<void> main(List<String> args) async {
  File file = File('4/data.txt');
  List<String> data1 = await file.readAsLines();
  List<List<List<String>>> data2 = [];
  List<List<List<int>>> data = [];
  List<int> numbers = data1.first.split(",").map((e) => int.parse(e)).toList();

  data1.skip(1).forEach((element) {
    if (element.isEmpty) {
      data2.add([]);
    } else {
      data2.last.add(element.split(" "));
    }
  });
  for (var list1 in data2) {
    for (var list2 in list1) {
      list2.removeWhere((element) => element == "");
    }
  }

  data2.forEach((list1) {
    data.add([]);
    list1.forEach((list2) {
      data.last.add(list2.map((e) => int.parse(e)).toList());
    });
  });

  for (var i = 0; i < numbers.length; i++) {
    for (var iboard = 0; iboard < data.length; iboard++) {
      for (var il2 = 0; il2 < data[iboard].length; il2++) {
        for (var il3 = 0; il3 < data[iboard][il2].length; il3++) {
          var numb = data[iboard][il2][il3];
          if (numb == numbers[i]) data[iboard][il2][il3] = -1;
        }
      }
    }
    // print(numbers[i]);
    // print(data);
    if (numbers[i] == 17) {
      var a = 1;
    }
    var bingo = comprobarBingo(data, numbers);
    print(numbers[i]);

    if (bingo['fila'] != -1 &&
        (bingo['Tabla'] != -1 || bingo['columna'] != -1)) {
      print(data[bingo['Tabla']!]);
      var result = data[bingo['Tabla']!]
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
      exit(0);
    }
  }
}

Map<String, int> comprobarBingo(List<List<List<int>>> data, List<int> numbers) {
  bool exitLoop = false;
  var result = {'Tabla': -1, 'fila': -1, 'columna': -1};
  for (var i = 0; i < numbers.length; i++) {
    if (exitLoop) break;
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
            result = {'Tabla': iboard, "fila": il2};

            ///   print(result);
            exitLoop = true;
            break;
          }
        }
      }
    }
  }

  if (!exitLoop) {
    for (var i = 0; i < numbers.length; i++) {
      if (exitLoop) break;
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
              result = {'Tabla': iboard, "columna": il2};

              ///   print(result);
              exitLoop = true;
              break;
            }
          }

          // print(data[iboard][il2]);

        }
      }
    }
  }
  return result;
}
