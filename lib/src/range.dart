class Range {
  final int first;
  final int last;

  Range(this.first, this.last);

  Range.single(int val) : this(val, val);

  bool follows(Range other) => first - 1 == other.last;

  @override
  String toString() => first == last ? '$first' : '$first-$last';
}
