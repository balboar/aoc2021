import 'dart:io';
import 'dart:math';

late List<List<bool>> visited;
late List<List<int>> data;
late MyQueue queue = MyQueue();
int maxX = 0;
void main(List<String> args) {
  File file = File('bin/15/data.txt');
  data = file
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();

  maxX = data.first.length;

  createNextTile(List.from(data));
  //print(data);

  visited = List.generate(data.length,
      (index) => List.generate(data.first.length, (index) => false));

  var firstNode = Node(0, 0, 0);
  firstNode.distance = 0;
  visited[0][0] = true;
  queue.add(firstNode);

  while (queue.isNotEmpty) {
    Node currentNode = queue.first();
    if ((currentNode.x == data.first.length - 1) &&
        (currentNode.y == data.length - 1)) {
      print(currentNode.distance);
    }
    queue.removeFirst();
    // print(
    //     'currentNode x ${currentNode.x} y ${currentNode.y}  distance ${currentNode.distance}');

    visited[currentNode.y][currentNode.x] = true;
    currentNode.getUnvisitedNeighbors().forEach((Node neighbor) {
      neighbor.distance = currentNode.distance + neighbor.value;
      neighbor.parent = currentNode;

      queue.addOrUpdate(neighbor);
    });
  }
}

void createNextTile(List<List<int>> currentTile) {
  List<List<int>> tile = [];
  int count = data.length;

  for (int i = 0; i < currentTile.length; i++) {
    var row = currentTile[i];
    tile.add([]);
    if (data.length < maxX * 5) {
      data.add([]);
    }
    for (int j = 0; j < row.length; j++) {
      var element = row[j];
      tile.last.add(element + 1 > 9 ? 1 : element + 1);
    }
    //data[i].addAll(tile.last);

    for (var v = 0; v <= (count / maxX); v++) {
      int value = i + (v * maxX);
      if (value < maxX * 5) {
        if (data[value].length < maxX * 5) {
          data[value].addAll(tile.last);
        }
      }
    }
  }
  if (data.last.length < maxX * 5) {
    createNextTile(tile);
  }
}

class Node {
  final int x;
  final int y;
  final int value;
  double distance = double.infinity;
  Node? parent;

  Node(this.x, this.y, this.value, {this.parent});

  List<Node> getUnvisitedNeighbors() {
    List<Node> neighbors = [];
    if (x > 0) {
      searchForNode(x - 1, y, neighbors);
    }
    if (y > 0) {
      searchForNode(x, y - 1, neighbors);
    }
    if (x < data.first.length - 1) {
      searchForNode(x + 1, y, neighbors);
    }
    if (y < data.length - 1) {
      searchForNode(x, y + 1, neighbors);
    }

    return neighbors;
  }

  void searchForNode(int x1, int y1, List<Node> neighbors) {
    if ((!visited[y1][x1])) {
      var node = Node(x1, y1, data[y1][x1]);
      neighbors.add(node);
    }
  }
}

class MyQueue {
  late List<Node> nodes = [];

  bool get isNotEmpty => _isNotEmpty();

  void add(Node node) {
    nodes.add(node);
    nodes.sort((a, b) => a.distance.compareTo(b.distance));
  }

  void removeFirst() {
    nodes.removeAt(0);
  }

  bool _isNotEmpty() {
    return nodes.isNotEmpty;
  }

  Node first() {
    return nodes.first;
  }

  void addOrUpdate(Node node) {
    Node? nodeInQueue = null;
    try {
      nodeInQueue = nodes.firstWhere(
          (element) => (element.x == node.x && element.y == node.y));
    } catch (e) {}

    if (nodeInQueue == null) {
      nodes.add(node);
    } else {
      nodes[nodes.indexOf(nodeInQueue)].distance =
          min(nodes[nodes.indexOf(nodeInQueue)].distance, node.distance);
    }
    nodes.sort((a, b) => a.distance.compareTo(b.distance));
  }

  void printNode() {
    for (var item in nodes) {
      print('queue x ${item.x} y ${item.y}  distance ${item.distance}');
    }
  }
}
