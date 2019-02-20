import 'dart:async';

import 'package:flutter/material.dart';

class PullToReachScope extends InheritedWidget {
  Stream<int> get focusIndex => _focusIndex.stream;

  Stream<int> get selectIndex => _selectIndex.stream;

  final StreamController<int> _focusIndex = StreamController.broadcast();
  final StreamController<int> _selectIndex = StreamController.broadcast();

  final Function(int index) onFocus;
  final Function(int index) onSelect;

  PullToReachScope({
    Key key,
    @required Widget child,
    this.onFocus,
    this.onSelect,
  }) : super(key: key, child: child);

  static PullToReachScope of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(PullToReachScope)
          as PullToReachScope;

  void setFocusIndex(int index) {
    if (onFocus != null) onFocus(index);

    _focusIndex.add(index);
  }

  void setSelectIndex(int index) {
    if (onSelect != null) onSelect(index);

    _selectIndex.add(index);
  }

  @override
  bool updateShouldNotify(PullToReachScope old) => true;
}
