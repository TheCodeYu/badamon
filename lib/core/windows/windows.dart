import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

///桌面窗口基类
///
///

class TestApp extends BaseWindows {
  const TestApp(this.child, {Key? key, this.context, required this.name})
      : super(key: key);

  final Widget child;

  final String name;
  final BuildContext? context;
  @override
  String appName() => 'Test:' + name;

  @override
  Widget getChild() => child;

  @override
  BuildContext? getHomeContext() => context;
}

class Aaa extends StatefulWidget {
  const Aaa({Key? key}) : super(key: key);

  @override
  _AaaState createState() => _AaaState();
}

class _AaaState extends State<Aaa> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('qwewqeqweqwe'),
      ),
    );
  }
}

abstract class BaseWindows extends StatefulWidget {
  const BaseWindows({Key? key}) : super(key: key);

  Widget getChild();

  String appName();

  BuildContext? getHomeContext();
  @override
  _BaseWindowsState createState() => _BaseWindowsState();
}

class _BaseWindowsState extends State<BaseWindows> {
  late final Widget child;
  @override
  void initState() {
    child = widget.getChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MoveWindow(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appName()),
        ),
        body: child,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: widget.getHomeContext() != null
            ? IconButton(
                onPressed: () => Navigator.of(widget.getHomeContext()!).pop(),
                icon: Icon(Icons.arrow_back_ios),
              )
            : null,
      ),
    );
  }
}
