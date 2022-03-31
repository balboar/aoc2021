import 'dart:io';

Future<void> main(List<String> args) async {
  File file = File('5/data.txt');
  List<String> data = await file.readAsLines();
  Diagram diagram = Diagram();

  data.forEach((element) {
    Line line = Line(element);
    diagram.addLine(line);
  });

  print(diagram.numberOfOverlapingLines());

  // 0,9 -> 5,9
}

class Line {
  late int x1;
  late int x2;
  late int y1;
  late int y2;
  List<Point> points = [];
  String input;

  Line(this.input) {
    int incrementX = 0;
    int incrementY = 0;
    var aux = input.split(' -> ');
    var firstPoint = aux[0].split(',');
    x1 = int.parse(firstPoint.first);
    y1 = int.parse(firstPoint.last);
    var secondPoint = aux[1].split(',');
    x2 = int.parse(secondPoint.first);
    y2 = int.parse(secondPoint.last);
    incrementX = x1 > x2 ? -1 : 1;
    incrementY = y1 > y2 ? -1 : 1;
    if ((x1 == x2)) {
      for (var i = 0; i <= (y2 - y1).abs(); i++) {
        points.add(Point(x1, y1 + incrementY * i));
      }
    } else if (y1 == y2) {
      for (var i = 0; i <= (x2 - x1).abs(); i++) {
        points.add(Point(x1 + incrementX * i, y1));
      }
    } else {
      for (var i = 0; i <= (x2 - x1).abs(); i++) {
        points.add(Point(x1 + incrementX * i, y1 + incrementY * i));
      }
    }
  }
}

class Point {
  int x;
  int y;
  Point(this.x, this.y);
}

class Diagram {
  Map<String, int> diagram = {};

  void addLine(Line line) {
    if (line.points.length > 0) {
      line.points.forEach((point) {
        var key = '${point.x},${point.y}';
        if (diagram.containsKey(key))
          diagram.update(key, (value) => value + 1);
        else {
          diagram[key] = 1;
        }
      });
    }
  }

  int numberOfOverlapingLines() {
    diagram.removeWhere((key, value) => value < 2);
    return diagram.length;
  }
}
