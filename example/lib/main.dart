import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  String _gesture = "";
  TapPosition _position = TapPosition(Offset.zero, Offset.zero);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PositionedTapDetector(
                onTap: _onTap,
                onDoubleTap: _onDoubleTap,
                onLongPress: _onLongPress,
                child: Container(
                  width: 160.0,
                  height: 160.0,
                  color: Colors.redAccent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text("Gesture: $_gesture\n"
                    "Global: ${_formatOffset(_position.global)}\n"
                    "Local: ${_formatOffset(_position.local)}"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(TapPosition position) => _updateState('single tap', position);

  void _onDoubleTap(TapPosition position) =>
      _updateState('double tap', position);

  void _onLongPress(TapPosition position) =>
      _updateState('long press', position);

  void _updateState(String gesture, TapPosition position) {
    setState(() {
      _gesture = gesture;
      _position = position;
    });
  }

  String _formatOffset(Offset offset) =>
      "${offset.dx.toStringAsFixed(1)}, ${offset.dy.toStringAsFixed(1)}";
}
