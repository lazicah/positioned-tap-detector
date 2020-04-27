# positioned-tap-detector

[![pub package](https://img.shields.io/pub/v/positioned_tap_detector.svg)](https://pub.dartlang.org/packages/positioned_tap_detector)

Flutter widget allowing to receive tap callbacks, together with their position on the screen. It supports `onTap`, `onDoubleTap` and `onLongPress` gestures. Each callback function is invoked with `TapPosition` object that provides `global` and `local` touch position. To adjust maximum time allowed between double-tap gesture consecutive taps, specify an additional `doubleTapDelay` parameter:

```Dart
PositionedTapDetector(
  onTap: (position) => _printTap('Single tap', position),
  onDoubleTap: (position) => _printTap('Double tap', position),
  onLongPress: (position) => _printTap('Long press', position),
  doubleTapDelay: Duration(milliseconds: 500),
  child: ...,
)

void _printTap(String gesture, TapPosition position) => 
    print('$gesture: ${position.global}, ${position.local}');
```

![PositionedTapDetector demo](https://thumbs.gfycat.com/SameTautHammerheadbird-small.gif)

### Controller

In case you need to wrap another `GestureDetector` below in the widget tree, pass an additional `PositionedTapController` parameter and invoke its callback methods whenever relevant gesture takes place:

```Dart
final _controller = PositionedTapController();

Widget build(BuildContext context) {
  // ...
    child: PositionedTapDetector(
      // ...
      controller: _controller,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: _controller.onTapDown,
        onLongPress: _controller.onLongPress,
        behavior: ...,
        child: ...,
      ),
    ),
}

void _handleTap() {
  // ...
  _controller.onTap();
}
```

**Note:** always remember to pass `onTapDown` callback to `PositionedTapController`.

### Drawbacks

**Custom GestureDetector**

`PositionedTapDetector` will not invoke *onDoubleTap* callback in case there's `GestureDetector` underneath it in the widget tree **that also specifies *onDoubleTap* parameter**. Since Flutter framework doesn't invoke its `onTapDown` callback when detector is double-tapped, *positioned detector* is unable to receive tap positions and therefore detect double-tap gestures.


**Using with `TextField`**

`TextField` makes it a bit tricky to catch tap events, here is what the documentation says:

> Handling some of those events by wrapping the text field with a competing GestureDetector is problematic.

To make it work, it is necessary to wrap `TextField` with `AbsorbPointer` (so that tap events are properly delivered to `PositionedTapDetector`) but then you need to remember to request focus on the text input manually in order to activate it:

```Dart
PositionedTapDetector(
  onTap: _onTapPosition,
  onLongPress: (_) => _focusNode.requestFocus(),
  child: AbsorbPointer(
    child: TextField(focusNode: _focusNode),
  ),
)
```
