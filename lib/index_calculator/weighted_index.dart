import 'package:meta/meta.dart';

@immutable
class WeightedIndex {
  final int index;
  final double weight;

  WeightedIndex({
    @required this.index,
    this.weight = 1,
  });
}
