import 'dart:io';

void main(List<String> args) {
  Player player1 = Player();
  Player player2 = Player();
  Dice dice = Dice();
  var fileText = File('bin/21/data.txt').readAsLinesSync();
  player1.positionOnBoard = int.parse(fileText.first
      .substring(fileText.first.length - 1, fileText.first.length));
  player2.positionOnBoard = int.parse(
      fileText.last.substring(fileText.last.length - 1, fileText.last.length));

  while (true) {
    //  print('player 1');
    player1.move(dice);

    //print('Player 1 ${player1.score}');
    if (player1.score >= 1000) {
      print('Player 1 wins');
      print(dice.timesRolled * player2.score);
      break;
    }
    //  print('player 2');
    player2.move(dice);
    // print('Player 2 ${player2.score}');
    if (player2.score >= 1000) {
      print('Player 2 wins');
      print(dice.timesRolled * player1.score);
      break;
    }
  }
}

class Player {
  int positionOnBoard = 0;
  int score = 0;
  void move(Dice dice) {
    for (var i = 0; i < 3; i++) {
      dice.roll();
      //  print('dice number ${dice.number}');

      positionOnBoard += dice.number;

      if (positionOnBoard > 10) {
        positionOnBoard = positionOnBoard.remainder(10);
        if (positionOnBoard == 0) {
          positionOnBoard = 10;
        }
      }
      //  print('position $positionOnBoard, score $score');
    }
    score += positionOnBoard;
  }
}

class Dice {
  int number = 0;
  int timesRolled = 0;

  void roll() {
    number++;
    timesRolled++;
    if (number > 100) number = 1;
  }
}
