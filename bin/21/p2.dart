List<List<int>> rf = [
  [3, 1],
  [4, 3],
  [5, 6],
  [6, 7],
  [7, 6],
  [8, 3],
  [9, 1]
];

void main(List<String> args) {
  print(wins(3, 21, 2, 21));
}

List<int> wins(int p1, int t1, int p2, int t2) {
  if (t2 <= 0) {
    return [0, 1];
  }
  var win = [0, 0];
  for (var roll in rf) {
    var aux = wins(p2, t2, (p1 + roll[0]).remainder(10),
        t1 - 1 - (p1 + roll[0]).remainder(10));
    print(aux);
    win[0] = win[0] + roll[1] * aux[1];
    win[1] = win[1] + roll[1] * aux[0];
  }
  return win;
}
