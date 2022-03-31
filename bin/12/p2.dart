import 'dart:io';

late List<String> data;
Map<String, List<String>> paths = {};
List<List<String>> allPaths = [];
void main(List<String> args) {
  File file = File('12/data.txt');
  data = file.readAsLinesSync().toList();

  data.forEach((element) {
    List<String> aux = element.split('-');
    if ((aux.first != 'end') && (aux.last != 'start')) {
      if (paths.containsKey(aux.first)) {
        paths[aux.first]!.add(aux.last);
      } else
        paths[aux.first] = List.from([aux.last]);
    }
    if (aux.first != 'start') {
      {
        if (paths.containsKey(aux.last)) {
          paths[aux.last]!.add(aux.first);
        } else
          paths[aux.last] = List.from([aux.first]);
      }
    }
  });
  print(paths);
  travelPath('start', [], false);
  allPaths.removeWhere((element) => element.last != 'end');
  allPaths.forEach((element) {
    print(element);
  });
  print(allPaths.length);
}

void travelPath(
    String path, List<String> currentPath, bool secondTimeSmallCave) {
  if (path != 'end') {
    paths[path]!.forEach((element) {
      // print('element $element');
      allPaths.add([]);
      allPaths.last = List.of(currentPath);
      //   print(secondTimeSmallCave);
      //   print(allPaths.last);
      if (!allPaths.last.contains(element)) {
        allPaths.last.add(element);
        travelPath(element, allPaths.last, secondTimeSmallCave);
      } else if (allPaths.last.contains(element)) {
        if (element == element.toUpperCase()) {
          allPaths.last.add(element);
          travelPath(element, allPaths.last, secondTimeSmallCave);
        } else {
          if (!hasTwoSmallCaves(List.of(allPaths.last))) {
            allPaths.last.add(element);
            secondTimeSmallCave = true;
            travelPath(element, allPaths.last, secondTimeSmallCave);
          }
        }
      }
    });
  }
}

bool hasTwoSmallCaves(List<String> data) {
  Map<String, int> caves = {};
  data.sort();
  data.forEach((element) {
    if (element == element.toLowerCase()) {
      if (caves.containsKey(element)) {
        caves.update(element, (value) => value = value + 1);
      } else
        caves[element] = 1;
    }
  });
  List<int> values = caves.values.toList();
  values.sort();

  return values.length > 0 ? values.last == 2 : false;
}
