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

  travelPath('start', []);
  allPaths.removeWhere((element) => element.last != 'end');
  print(allPaths.length);
}

void travelPath(String path, List<String> currentPath) {
  if (path != 'end') {
    paths[path]!.forEach((element) {
      allPaths.add([]);
      allPaths.last = List.of(currentPath);
      if (!allPaths.last.contains(element)) {
        allPaths.last.add(element);
        travelPath(element, allPaths.last);
      } else if (allPaths.last.contains(element)) {
        if (element == element.toUpperCase()) {
          allPaths.last.add(element);
          travelPath(element, allPaths.last);
        }
      }
    });
  }
}
