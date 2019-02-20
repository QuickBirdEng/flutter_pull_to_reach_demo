import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pull_down_to_reach/widgets/pull_to_reach_scope.dart';

@immutable
class Reachable extends StatefulWidget {
  final Widget child;
  final int index;

  final ValueChanged<bool> onFocusChanged;
  final VoidCallback onSelect;

  Reachable({
    @required this.child,
    @required this.index,
    this.onFocusChanged,
    this.onSelect,
  });

  @override
  ReachableState createState() => ReachableState();
}

class ReachableState extends State<Reachable> {
  StreamSubscription<int> _focusSubscription;
  StreamSubscription<int> _selectionSubscription;

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void didChangeDependencies() {
    _focusSubscription?.cancel();
    _selectionSubscription?.cancel();

    _focusSubscription =
        PullToReachScope.of(context).focusIndex.listen(_onFocusChanged);

    _selectionSubscription =
        PullToReachScope.of(context).selectIndex.listen(_onSelectionChanged);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusSubscription?.cancel();
    _selectionSubscription?.cancel();
    super.dispose();
  }

  // -----
  // Handle Notifications
  // -----

  void _onFocusChanged(int newIndex) {
    if (widget.onFocusChanged == null) return;
    widget.onFocusChanged(newIndex == widget.index);
  }

  void _onSelectionChanged(int newIndex) {
    if (widget.onSelect == null) return;
    if (newIndex == widget.index) widget.onSelect();
  }
}
