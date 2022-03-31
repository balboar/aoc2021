import 'dart:io';

import 'dart:math';

const x1 = 88;
const x2 = 125;
const y2 = -157;
const y1 = -103;
int posX = 0;
int posY = 0;
int velX = 0;
int velY = 0;
int maxY = 0;
int count = 0;
bool found = false;

List<Point> data = [];

void main(List<String> args) {
  computePoints(29, -6);
  int diffX = x1 - posX;
  for (var i = -1200; i < 1200; i++) {
    for (var j = -160; j < 1000; j++) {
      computePoints(i, j);
      // if (found) {
      //   print('x $i  y $j');
      // }
    }
  }
  print(count);
}

void move() {
  posX = posX + velX;
  posY = posY + velY;
}

void computePoints(int velX, int velY) {
  int x = 0;
  int y = 0;
  int vX = velX;
  int vY = velY;
  x += vX.toInt();
  y += vY.toInt();
  maxY = 0;
  found = false;
  for (var i = 0; i < 800; i++) {
    if (vX > 0) {
      vX--;
    } else if (vX < 0) {
      vX++;
    }

    vY--;
    x += vX.toInt();
    y += vY.toInt();
    maxY = max(maxY, y);
    if ((found == false) && (y >= y2) && (y <= y1) && (x >= x1) && (x <= x2)) {
      found = true;
      count++;
      break;
      //  print(maxY);
    }
  }

  // print(data);
}
