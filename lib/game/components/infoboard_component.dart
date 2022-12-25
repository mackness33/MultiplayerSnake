import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/components/player_points_component.dart';
import 'package:multiplayersnake/game/components/time_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';

class PointsBoardComponent extends Component {
  PointsBoardComponent(this.board);

  final Rect board;

  @override
  Future<void>? onLoad() async {
    double x = board.width / 6;
    double progressivePos = 0;
    await super.onLoad();
    await addAll([
      PlayerPointsComponent(
        board,
        const Color.fromARGB(255, 24, 196, 53),
        Vector2(progressivePos += x, board.height / 2),
      ),
      PlayerPointsComponent(
        board,
        const Color.fromARGB(255, 15, 39, 217),
        Vector2(progressivePos += x, board.height / 2),
      ),
      TimeComponent(
        board,
        Vector2(progressivePos += x, board.height / 2),
      ),
      PlayerPointsComponent(
        board,
        const Color.fromARGB(255, 211, 237, 15),
        Vector2(progressivePos += x, board.height / 2),
      ),
      PlayerPointsComponent(
        board,
        const Color.fromARGB(255, 196, 41, 24),
        Vector2(progressivePos += x, board.height / 2),
      ),
    ]);
  }

  @override
  void render(Canvas canvas) {
    // voidBackground
    canvas.drawRect(Rect.fromLTWH(0, 0, board.width, board.height),
        Paint()..color = const Color.fromARGB(255, 9, 7, 95));
  }
}
