// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class SliderDemo extends StatefulWidget {
  static const String routeName = '/material/slider';

  @override
  _SliderDemoState createState() => new _SliderDemoState();
}

Path _triangle(double size, Offset thumbCenter, {bool invert = false}) {
  final Path thumbPath = new Path();
  final double height = math.sqrt(3.0) / 2.0;
  final double halfSide = size / 2.0;
  final double centerHeight = size * height / 3.0;
  final double sign = invert ? -1.0 : 1.0;
  thumbPath.moveTo(thumbCenter.dx - halfSide, thumbCenter.dy + sign * centerHeight);
  thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 2.0 * sign * centerHeight);
  thumbPath.lineTo(thumbCenter.dx + halfSide, thumbCenter.dy + sign * centerHeight);
  thumbPath.close();
  return thumbPath;
}

class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 4.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled ? const Size.fromRadius(_thumbSize) : const Size.fromRadius(_disabledThumbSize);
  }

  static final Tween<double> sizeTween = new Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final double size = _thumbSize * sizeTween.evaluate(enableAnimation);
    final Path thumbPath = _triangle(size, thumbCenter);
    canvas.drawPath(thumbPath, new Paint()..color = colorTween.evaluate(enableAnimation));
  }
}

class _CustomValueIndicatorShape extends SliderComponentShape {
  static const double _indicatorSize = 4.0;
  static const double _disabledIndicatorSize = 3.0;
  static const double _slideUpHeight = 40.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size.fromRadius(isEnabled ? _indicatorSize : _disabledIndicatorSize);
  }

  static final Tween<double> sizeTween = new Tween<double>(
    begin: _disabledIndicatorSize,
    end: _indicatorSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween enableColor = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.valueIndicatorColor,
    );
    final Tween<double> slideUpTween = new Tween<double>(
      begin: 0.0,
      end: _slideUpHeight,
    );
    final double size = _indicatorSize * sizeTween.evaluate(enableAnimation);
    final Offset slideUpOffset = new Offset(0.0, -slideUpTween.evaluate(activationAnimation));
    final Path thumbPath = _triangle(
      size,
      thumbCenter + slideUpOffset,
      invert: true,
    );
    final Color paintColor = enableColor.evaluate(enableAnimation).withAlpha((255.0 * activationAnimation.value).round());
    canvas.drawPath(
      thumbPath,
      new Paint()..color = paintColor,
    );
    canvas.drawLine(
        thumbCenter,
        thumbCenter + slideUpOffset,
        new Paint()
          ..color = paintColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);
    labelPainter.paint(canvas, thumbCenter + slideUpOffset + new Offset(-labelPainter.width / 2.0, -labelPainter.height - 4.0));
  }
}

class _SliderDemoState extends State<SliderDemo> {
  double _value = 25.0;
  double _discreteValue = 20.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(title: const Text('Sliders')),
      body: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Slider(
                  value: _value,
                  min: 0.0,
                  max: 100.0,
                  onChanged: (double value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                const Text('Continuous'),
              ],
            ),
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Slider(value: 0.25, onChanged: null),
                Text('Disabled'),
              ],
            ),
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Slider(
                  value: _discreteValue,
                  min: 0.0,
                  max: 200.0,
                  divisions: 5,
                  label: '${_discreteValue.round()}',
                  onChanged: (double value) {
                    setState(() {
                      _discreteValue = value;
                    });
                  },
                ),
                const Text('Discrete'),
              ],
            ),
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    activeTrackColor: Colors.deepPurple,
                    inactiveTrackColor: Colors.black26,
                    activeTickMarkColor: Colors.white70,
                    inactiveTickMarkColor: Colors.black,
                    overlayColor: Colors.black12,
                    thumbColor: Colors.deepPurple,
                    valueIndicatorColor: Colors.deepPurpleAccent,
                    thumbShape: new _CustomThumbShape(),
                    valueIndicatorShape: new _CustomValueIndicatorShape(),
                    valueIndicatorTextStyle: theme.accentTextTheme.body2.copyWith(color: Colors.black87),
                  ),
                  child: new Slider(
                    value: _discreteValue,
                    min: 0.0,
                    max: 200.0,
                    divisions: 5,
                    semanticFormatterCallback: (double value) => value.round().toString(),
                    label: '${_discreteValue.round()}',
                    onChanged: (double value) {
                      setState(() {
                        _discreteValue = value;
                      });
                    },
                  ),
                ),
                const Text('Discrete with Custom Theme'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
