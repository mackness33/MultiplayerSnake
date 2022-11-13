import 'package:multiplayersnake/game/utils/range.dart';

abstract class CurveComponent {
  late Range _curve;

  set curve(int current) => _curve = Range(current, 2);

  int get curve => _curve.current;

  void stir(int direction) {
    if (direction != curve) {
      if (direction > curve) {
        _curve.increase();
      } else {
        _curve.decrease();
      }
    }
  }
}
