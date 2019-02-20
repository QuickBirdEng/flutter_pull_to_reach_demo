import 'package:meta/meta.dart';

List<R> mapIndex<R>({
  int start = 0,
  @required int end,
  @required R Function(int) mapper,
}) {
  List<R> result = List();

  for (int i = start; i < end; i++) {
    result.add(mapper(i));
  }

  return result;
}

List<R> mapIndexed<T, R>(List<T> list, R Function(int, T) mapper) {
  List<R> result = List();
  for (int i = 0; i < list.length; i++) {
    result.add(mapper(i, list[i]));
  }

  return result;
}

double sum<T>({@required List<T> items, @required double Function(T) mapper}) {
  double sum = 0;
  items.forEach((item) => sum += mapper(item));
  return sum;
}
