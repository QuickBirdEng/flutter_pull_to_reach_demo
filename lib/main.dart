import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_down_to_reach/widgets/pull_to_reach_scope.dart';
import 'package:pull_down_to_reach/widgets/reachable_icon.dart';
import 'package:pull_down_to_reach/widgets/scroll_to_index_converter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: isDarkModeEnabled ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: LayoutBuilder(builder: (context, constraints) {
        return PullToReachScope(
          onFocus: (index) {
            if (index > 0 && index < 4) {
              lightImpact();
            }
          },
          onSelect: (index) {
            if (index > 0 && index < 4) {
              heavyImpact();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                ReachableIcon(
                  child: Icon(Icons.invert_colors),
                  index: 3,
                  onSelect: () =>
                      setState(() => isDarkModeEnabled = !isDarkModeEnabled),
                ),
                ReachableIcon(
                  child: Icon(Icons.search),
                  index: 2,
                  onSelect: () => _routeToPage(context, "search!"),
                ),
                ReachableIcon(
                    child: Icon(Icons.settings),
                    index: 1,
                    onSelect: () => _routeToPage(context, "settings!")),
              ],
            ),
            body: ScrollToIndexConverter(
              itemCount: 4,
              child: _buildList(),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildList() => ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.lightBlue[100 * (index % 9)],
          child: Text('list item $index'),
        );
      });

  void _routeToPage(BuildContext context, String text) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        var titleTheme = Theme.of(context)
            .primaryTextTheme
            .title
            .copyWith(color: Colors.black45);

        return Scaffold(
            appBar: AppBar(title: Text(text)),
            body: Center(child: Text(text, style: titleTheme)));
      },
    ));
  }

  Future<void> lightImpact() async {
    await SystemChannels.platform.invokeMethod(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.lightImpact',
    );
  }

  Future<void> heavyImpact() async {
    await SystemChannels.platform.invokeMethod(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.heavyImpact',
    );
  }
}
