import 'package:flutter/material.dart';

///Animates visibility change by scaling the widget to or from 0 using
///ScaleTransition.
class ScaleVisible extends StatefulWidget {
  ///Whether or not this widget should be shown.
  ///
  ///The scale animation will play once when this field changes.
  final bool visible;

  ///The widget that is shown or hidden by this widget.
  final Widget child;

  ///The alignment of the wrapped [ScaleTransition] widget.
  ///
  ///Defaults to [Alignment.center]
  final Alignment alignment;

  ///The duration of the scale animation.
  ///
  ///Defaults to ```300ms```.
  final Duration duration;

  ///The [Curve] that the scale animation will follow.
  ///
  ///Defaults to [Curves.linear]
  final Curve curve;

  ScaleVisible({
    Key key,
    @required this.visible,
    @required this.child,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _ScaleVisibleState createState() => _ScaleVisibleState();
}

class _ScaleVisibleState extends State<ScaleVisible>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: widget.curve, parent: _controller));
    
    //Ensure that the animation will not play if the widget starts as visible.
    if (widget.visible) {
      _controller.forward(from: _controller.upperBound);
    }
  }

  @override
  void didUpdateWidget(ScaleVisible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
