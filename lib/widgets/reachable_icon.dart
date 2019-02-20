import 'package:flutter/material.dart';
import 'package:pull_down_to_reach/widgets/reachable.dart';

class ReachableIcon extends StatefulWidget {
  final Widget child;
  final int index;
  final VoidCallback onSelect;

  ReachableIcon({
    @required this.child,
    @required this.index,
    @required this.onSelect,
  });

  @override
  _ReachableIconState createState() => _ReachableIconState();
}

class _ReachableIconState extends State<ReachableIcon> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Reachable(
      index: widget.index,
      onSelect: widget.onSelect,
      onFocusChanged: (isFocused) {
        setState(() => _isFocused = isFocused);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isFocused
              ? Theme.of(context).iconTheme.color.withOpacity(.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: GestureDetector(onTap: widget.onSelect, child: widget.child),
      ),
    );
  }
}
