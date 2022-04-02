import 'dart:io';

import 'dart:math';

List<List<String>> image = [];
List<List<String>> newImage = [];
String iea = '';
void main(List<String> args) {
  int count = 0;
  var fileText = File('bin/20/data.txt').readAsLinesSync();
  // iea  = image enhancement algoritihm
  iea = fileText.first;
  fileText.removeRange(0, 2);
  image = fileText.map((e) => e.split('').toList()).toList();

  for (var i = 0; i < 50; i++) {
    addExternalPixels(i);
    addExternalPixels(i);
    runOnce(i);

    image.clear();
    for (var item in newImage) {
      image.add(List.of(item));
    }
    image.removeRange(0, 1);
    image.removeRange(image.length - 1, image.length);
    for (var i = 0; i < image.length; i++) {
      image[i].removeRange(0, 1);
      image[i].removeRange(image[i].length - 1, image[i].length);
    }
    for (var item in image) {
      print(item.join());
    }
    print(i);
  }

  for (var item in image) {
    print(item.join());
  }

  for (var row in image) {
    for (var element in row) {
      if (element == '#') count += 1;
    }
  }

  print(count);
}

void parse9PixelWindow(Point center, int index) {
  List<String> ninePixelImage = [];

  ninePixelImage = ['.', '.', '.', '.', '.', '.', '.', '.', '.'];

  for (var y = -1; y < 2; y++) {
    var auxY = center.y.toInt() + y;
    if ((auxY >= 0) && (auxY < image.length)) {
      for (var x = -1; x < 2; x++) {
        var auxX = center.x.toInt() + x;
        if ((auxX >= 0) && (auxX < image.first.length)) {
          ninePixelImage[x + 1 + (y + 1) * 3] = image[auxY][auxX];
        }
      }
    }
  }

  String outPixel = ninePixelImage.join();
  outPixel = outPixel.replaceAll('.', '0');
  outPixel = outPixel.replaceAll('#', '1');
  int denary = int.parse(outPixel, radix: 2);
  newImage[center.y.toInt()][center.x.toInt()] = iea.split('')[denary];
}

void runOnce(int index) {
  newImage.clear();
  for (var item in image) {
    newImage.add(List.of(item));
  }
  for (var row = 1; row < image.length - 1; row++) {
    for (var col = 1; col < image.first.length - 1; col++) {
      parse9PixelWindow(Point(row, col), index);
    }
  }
}

void addExternalPixels(int index) {
  var filler = '.';
  if (index.remainder(2) != 0) {
    filler = '#';
  }
  image.insert(0, List.generate(image.first.length, (index) => filler));
  image.add(List.generate(image.first.length, (index) => filler));
  for (var i = 0; i < image.length; i++) {
    image[i].add(filler);
    image[i].insert(0, filler);
  }
}
