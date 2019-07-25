import 'package:flutter/material.dart';

///Animates visibility changes by changing the opacity of the child widget from
///0 to 1 using FadeTransition.
class FadeVisible extends StatefulWidget {
  ///Whether or not this widget should be shown.
  ///
  ///The fade animation will play once when this field changes.
  final bool visible;

  ///The widget that is shown or hidden by this widget.
  final Widget child;

  ///The [Duration] of the fade animation.
  ///
  ///Defaults to ```300ms```.
  final Duration duration;

  ///The [Curve] that the fade animation will follow.
  ///
  ///Defaults to [Curves.linear].
  final Curve curve;

  FadeVisible({
    Key key,
    @required this.visible,
    @required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _FadeVisibleState createState() => _FadeVisibleState();
}

class _FadeVisibleState extends State<FadeVisible>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: widget.curve, parent: _controller));

    //Ensure that the animation will not play if the widget starts as visible.
    if (widget.visible) {
      _controller.forward(from: _controller.upperBound);
    }
  }

  @override
  void didUpdateWidget(FadeVisible oldWidget) {
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
