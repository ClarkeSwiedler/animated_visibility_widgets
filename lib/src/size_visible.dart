import 'package:flutter/material.dart';

///Animates visibility change by sizing and clipping child using SizeTransition.
class SizeVisible extends StatefulWidget {
  ///Whether or not this widget should be shown.
  ///
  ///The sizing animation will play once when this field changes.
  final bool visible;

  ///The widget that is shown or hidden by this widget.
  final Widget child;

  ///The axis along which the child widget should be sized.
  ///
  ///Defaults to [Axis.vertical]
  final Axis axis;

  ///The alignment of the sizing along the given axis.
  ///
  ///Defaults to ```0.0```, which will cause a clip toward the center.
  final double axisAlignment;

  ///The [Duration] of the size animation.
  ///
  ///Defaults to ```300ms```.
  final Duration duration;

  ///The [Curve] that the size animation will follow.
  ///
  ///Defaults to [Curves.linear]
  final Curve curve;

  SizeVisible({
    Key key,
    @required this.visible,
    @required this.child,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  });

  @override
  _SizeVisibleState createState() => _SizeVisibleState();
}

class _SizeVisibleState extends State<SizeVisible>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: widget.curve, parent: _controller));

    //Ensure that the animation will not play if the widget starts as visible.
    if (widget.visible) {
      _controller.forward(from: _controller.upperBound);
    }
  }

  @override
  void didUpdateWidget(SizeVisible oldWidget) {
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
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      child: widget.child,
    );
  }
}
