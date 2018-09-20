import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

class PositionedTapDetector extends StatefulWidget {
  PositionedTapDetector({
    Key key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.doubleTapDelay: _DEFAULT_DELAY,
  }) : super(key: key);

  static const _DEFAULT_DELAY = Duration(milliseconds: 250);
  static const _DOUBLE_TAP_MAX_OFFSET = 48.0;

  final Widget child;
  final TapPositionCallback onTap;
  final TapPositionCallback onDoubleTap;
  final TapPositionCallback onLongPress;
  final Duration doubleTapDelay;

  @override
  _TapPositionDetectorState createState() => _TapPositionDetectorState();
}

class _TapPositionDetectorState extends State<PositionedTapDetector> {
  StreamController<TapDownDetails> _controller = StreamController();
  Stream<TapDownDetails> get _stream => _controller.stream;
  Sink<TapDownDetails> get _sink => _controller.sink;

  TapDownDetails _pendingTap;
  TapDownDetails _firstTap;

  @override
  void initState() {
    _stream
        .timeout(widget.doubleTapDelay)
        .handleError(_onTimeout, test: _isTimeoutError)
        .listen(_onTapConfirmed);
    super.initState();
  }

  void _onTimeout(dynamic error) {
    if (_firstTap != null && _pendingTap == null) {
      _postCallback(_firstTap, widget.onTap);
    }
  }

  bool _isTimeoutError(dynamic error) => error is TimeoutException;

  void _onTapConfirmed(TapDownDetails details) {
    if (_firstTap == null) {
      _firstTap = details;
    } else {
      _handleSecondTap(details);
    }
  }

  void _handleSecondTap(TapDownDetails secondTap) {
    if (_isDoubleTap(_firstTap, secondTap)) {
      _postCallback(secondTap, widget.onDoubleTap);
    } else {
      _postCallback(_firstTap, widget.onTap);
      _postCallback(secondTap, widget.onTap);
    }
  }

  bool _isDoubleTap(TapDownDetails d1, TapDownDetails d2) {
    final dx = (d1.globalPosition.dx - d2.globalPosition.dx);
    final dy = (d1.globalPosition.dy - d2.globalPosition.dy);
    return sqrt(dx * dx + dy * dy) <=
        PositionedTapDetector._DOUBLE_TAP_MAX_OFFSET;
  }

  void _onTapDown(TapDownDetails details) {
    _pendingTap = details;
  }

  void _onTap() {
    if (widget.onDoubleTap == null) {
      _postCallback(_pendingTap, widget.onTap);
    } else {
      _sink.add(_pendingTap);
    }
    _pendingTap = null;
  }

  void _onLongPress() {
    if (_firstTap == null) {
      _postCallback(_pendingTap, widget.onLongPress);
    } else {
      _sink.add(_pendingTap);
      _pendingTap = null;
    }
  }

  void _postCallback(
      TapDownDetails details, TapPositionCallback callback) async {
    _firstTap = null;
    callback(_getTapPositions(details));
  }

  TapPosition _getTapPositions(TapDownDetails details) {
    final topLeft = _getWidgetTopLeft();
    final global = details.globalPosition;
    final relative = topLeft != null ? global - topLeft : null;
    return TapPosition(global, relative);
  }

  Offset _getWidgetTopLeft() {
    final translation =
        context?.findRenderObject()?.getTransformTo(null)?.getTranslation();
    return translation != null ? Offset(translation.x, translation.y) : null;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: _onTap,
      onLongPress: _onLongPress,
      onTapDown: _onTapDown,
    );
  }
}

typedef TapPositionCallback(TapPosition position);

class TapPosition {
  TapPosition(this.global, this.relative);
  Offset global;
  Offset relative;

  @override
  bool operator ==(dynamic other) {
    if (other is! TapPosition) return false;
    final TapPosition typedOther = other;
    return global == typedOther.global && relative == other.relative;
  }

  @override
  int get hashCode => hashValues(global, relative);
}
