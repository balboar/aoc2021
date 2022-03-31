import 'dart:io';

import 'dart:math';

const x1 = 20;
const x2 = 30;
const y2 = -157;
const y1 = -103;
int posX = 0;
int posY = 0;
int velX = 0;
int velY = 0;
int maxY = 0;

List<Point> data = [];

void main(List<String> args) {
  int diffX = x1 - posX;
  for (var i = 0; i < 500; i++) {
    computePoints(15, i);
  }
}

void move() {
  posX = posX + velX;
  posY = posY + velY;
}

void computePoints(int velX, int velY) {
  bool found = false;

  int x = 0;
  int y = 0;
  int vX = velX;
  int vY = velY;
  x += vX.toInt();
  y += vY.toInt();
  maxY = 0;
  found = false;
  for (var i = 0; i < 700; i++) {
    if (vX > 0) {
      vX--;
    } else if (vX < 0) {
      vX++;
    }

    vY--;
    x += vX.toInt();
    y += vY.toInt();
    maxY = max(maxY, y);
    if ((found == false) && (y >= y2) && (y <= y1)) {
      found = true;
      print(maxY);
    }
  }

  // print(data);
}
