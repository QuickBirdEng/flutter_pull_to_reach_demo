import 'package:meta/meta.dart';

@immutable
class Range {
  final int index;

  final double start;
  final double end;

  Range(this.index, this.start, this.end);

  bool isInRange(double value) => start < value && end > value;
}
