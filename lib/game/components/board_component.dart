import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/components/chessboard_component.dart';
import 'package:multiplayersnake/game/components/infoboard_component.dart';
import 'package:multiplayersnake/game/components/tapboard_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';

class BoardComponent extends Component {
  BoardComponent(this.screen, this.tileSize)
      : pointsBoard = PointsBoardComponent(
            Rect.fromLTWH(0, 0, screen.width, screen.height * 0.15));

  final Rect screen;
  final double tileSize;
  final PointsBoardComponent pointsBoard;

  @override
  Future<void>? onLoad() async {
    Rect pointsRect = Rect.fromLTWH(0, 0, screen.width, screen.height * 0.15);
    Rect playRect =
        Rect.fromLTWH(0, pointsRect.bottom, screen.width, screen.height * 0.85);
    await addAll([
      ChessBoardComponent(playRect, tileSize),
      TapBoardComponent(playRect, tileSize),
      pointsBoard,
    ]);
    await super.onLoad();
  }

  // Future<void> end() async => await pointsBoard.end();

  void addPlayers(List<String> players) => pointsBoard.addPlayers(players);
}
