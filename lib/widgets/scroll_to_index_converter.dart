import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_down_to_reach/index_calculator/index_calculator.dart';
import 'package:pull_down_to_reach/widgets/pull_to_reach_scope.dart';

class ScrollToIndexConverter extends StatefulWidget {
  final Widget child;
  final int itemCount;

  final double dragExtentPercentage;

  ScrollToIndexConverter({
    @required this.child,
    @required this.itemCount,
    this.dragExtentPercentage = 0.2,
  });

  @override
  _ScrollToIndexConverterState createState() => _ScrollToIndexConverterState();
}

class _ScrollToIndexConverterState extends State<ScrollToIndexConverter> {
  double _dragOffset = 0;
  int _itemIndex = 0;
  bool _shouldNotifyOnDragEnd = false;
  bool _pullToReachStarted = false;

  IndexCalculator indexCalculator;

  @override
  void initState() {
    indexCalculator = IndexCalculator(count: widget.itemCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );
  }

  // -----
  // Handle notifications
  // -----

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_didDragStart(notification)) {
      _dragOffset = 0;
      _pullToReachStarted = true;
    }

    if (_didDragEnd(notification)) {
      _dragOffset = 0;
      _pullToReachStarted = false;

      _notifySelectIfNeeded();
    }

    if (_pullToReachStarted) {
      _shouldNotifyOnDragEnd = true;
    } else {
      return false;
    }

    var progress = _calculateScrollProgress(notification);
    var index = indexCalculator.getIndexForScrollPercent(progress);

    if (_itemIndex != index) {
      _itemIndex = index;
      PullToReachScope.of(context).setFocusIndex(_itemIndex);
    }

    return false;
  }

  bool _didDragStart(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0) {
      return true;
    }

    return false;
  }

  bool _didDragEnd(ScrollNotification notification) {
    // Whenever dragDetails are null the scrolling happened without users input
    // meaning that the user release the finger --> drag has ended.
    // For Cupertino Scrollables the ScrollEndNotification can not be used
    // since it will be send after the list scroll has completely ended and
    // the list is in its initial state
    if (notification is ScrollUpdateNotification &&
        notification.dragDetails == null) {
      return true;
    }

    // For Material Scrollables we can simply use the ScrollEndNotification
    if (notification is ScrollEndNotification) {
      return true;
    }

    return false;
  }

  void _notifySelectIfNeeded() {
    if (_shouldNotifyOnDragEnd) {
      PullToReachScope.of(context).setFocusIndex(-1);
      PullToReachScope.of(context).setSelectIndex(_itemIndex);

      _shouldNotifyOnDragEnd = false;
    }
  }

  double _calculateScrollProgress(ScrollNotification notification) {
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollUpdateNotification) {
      _dragOffset -= notification.scrollDelta;
    }

    if (notification is OverscrollNotification) {
      _dragOffset -= notification.overscroll;
    }

    var percent = _dragOffset / (containerExtent * widget.dragExtentPercentage);

    return percent.clamp(0.0, 1.0);
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;

    notification.disallowGlow();
    return false;
  }
}
