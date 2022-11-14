import 'package:equatable/equatable.dart';

/// The board where the snake can move itself.
class BoardController extends Equatable {
  /// Convenient constructor.
  const BoardController(this.width, this.height)
      : assert(width > 0),
        assert(height > 0);

  /// The width.
  final int width;

  /// The height.
  final int height;

  @override
  List<Object> get props => [width, height];

  @override
  bool get stringify => true;
}
