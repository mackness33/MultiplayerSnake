class RangeWithHistory extends Range {
  int _previous;
  RangeWithHistory(int initialValue, int max)
      : _previous = initialValue,
        super(initialValue, max);

  int get previous => _previous;

  bool get asPrevious => _previous == _current;

  int get difference => _previous - _current;

  @override
  void absIncrease() {
    _previous = _current;
    super.absIncrease();
  }

  @override
  void absDecrease() {
    _previous = _current;
    super.absDecrease();
  }

  void keep() {
    _previous = _current;
  }

  @override
  void increase() {
    _previous = _current;
    super.increase();
  }

  @override
  void decrease() {
    _previous = _current;
    super.decrease();
  }
}

class Range {
  int _current;
  final int _range;

  Range(this._current, this._range);

  int get current => _current;

  void absIncrease() => _current = ++_current % _range;
  void absDecrease() => _current = --_current % _range;

  void increase() => _current = (++_current % _range) * _current.sign;
  void decrease() => _current = (--_current % _range) * _current.sign;
}
