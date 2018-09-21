# positioned-tap-detector

[![pub package](https://img.shields.io/pub/v/positioned_tap_detector.svg)](https://pub.dartlang.org/packages/positioned_tap_detector)

Flutter widget allowing to receive tap callbacks, together with their position on the screen. It supports `onTap`, `onDoubleTap` and `onLongPress` gestures. Each callback function is invoked with `TapPosition` object that provides `global` and `relative` touch position. To adjust maximum time allowed between double-tap gesture consecutive taps, specify an additional `doubleTapDelay` parameter.

```Dart
    PositionedTapDetector(
      onTap: (position) => _printTap('Single tap', position),
      onDoubleTap: (position) => _printTap('Double tap', position),
      onLongPress: (position) => _printTap('Long press', position),
      doubleTapDelay: Duration(milliseconds: 500),
      child: ...,
    )
    
    void _printTap(String gesture, TapPosition position) => 
        print('$gesture: ${position.global}, ${position.relative}');
```

![PositionedTapDetector demo](https://thumbs.gfycat.com/SameTautHammerheadbird-small.gif)
