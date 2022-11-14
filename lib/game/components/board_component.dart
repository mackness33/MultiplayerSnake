import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/components/chessboard_component.dart';
import 'package:multiplayersnake/game/components/tapboard_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/game/ui/colors.dart';

class BoardComponent extends Component {
  BoardComponent(this.screen, this.board, this.tileSize);

  final Rect screen;
  final BoardController board;
  final double tileSize;

  @override
  Future<void>? onLoad() async {
    await addAll([
      ChessBoardComponent(screen, board, tileSize),
      TapBoardComponent(screen, tileSize),
    ]);
    await super.onLoad();
  }
}
