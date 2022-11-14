import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/game/ui/colors.dart';

class ChessBoardComponent extends Component {
  ChessBoardComponent(this.screen, this.board, this.tileSize)
      : background = [
          Paint()..color = GameColors.background,
          Paint()..color = GameColors.backgroundChess,
          Paint()..color = GameColors.voidBackground,
        ];

  final Rect screen;
  final BoardController board;
  final double tileSize;
  final List<Paint> background;

  @override
  void render(Canvas canvas) {
    // voidBackground
    canvas.drawRect(Rect.fromLTWH(0, 0, tileSize, tileSize), background[2]);

    // chessBackground
    for (int i = 0; i < board.width; i++) {
      for (int j = 0; j < board.height; j++) {
        canvas.drawRect(
          Rect.fromLTWH(
            tileSize * i,
            tileSize * j,
            tileSize,
            tileSize,
          ),
          ((j + i) % 2 == 0) ? background[1] : background[0],
        );
      }
    }
  }
}
