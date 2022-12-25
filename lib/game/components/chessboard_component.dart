import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/game/ui/colors.dart';

class ChessBoardComponent extends Component {
  ChessBoardComponent(this.board, this.tileSize)
      : background = [
          Paint()..color = GameColors.background,
          Paint()..color = GameColors.backgroundChess,
          Paint()..color = GameColors.voidBackground,
        ],
        tilesInBoard = Vector2(board.width / tileSize, board.height / tileSize);

  final Rect board;
  final Vector2 tilesInBoard;
  final double tileSize;
  final List<Paint> background;

  @override
  void render(Canvas canvas) {
    // voidBackground
    canvas.drawRect(
        Rect.fromLTWH(0, 0, board.width, board.height), background[2]);

    // chessBackground
    for (int i = 0; i < tilesInBoard.x; i++) {
      for (int j = 0; j < tilesInBoard.y; j++) {
        canvas.drawRect(
          Rect.fromLTWH(
            tileSize * i,
            (tileSize * j) + board.top,
            tileSize,
            tileSize,
          ),
          ((j + i) % 2 == 0) ? background[1] : background[0],
        );
      }
    }
  }
}
