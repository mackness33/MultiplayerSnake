import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board.dart';
import 'package:multiplayersnake/game/ui/colors.dart';

class Background extends Component {
  Background(this.screen, this.board, this.tileSize);

  final Rect screen;
  final EntitySize board;
  final double tileSize;

  @override
  void render(Canvas canvas) {
    final fullBackground = Rect.fromLTWH(0, 0, screen.width, screen.height);
    final paint = Paint();
    paint.color = GameColors.voidBackground;
    canvas.drawRect(fullBackground, paint);

    final boardBackground =
        Rect.fromLTWH(0, 0, board.width * tileSize, board.height * tileSize);
    paint.color = GameColors.background;
    canvas.drawRect(boardBackground, paint);

    paint.color = GameColors.backgroundChess;
    for (var i = 0; i < board.width; i++) {
      for (var j = 0; j < board.height; j++) {
        if ((j + i) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              tileSize * i,
              tileSize * j,
              tileSize,
              tileSize,
            ),
            paint,
          );
        }
      }
    }
  }
}
