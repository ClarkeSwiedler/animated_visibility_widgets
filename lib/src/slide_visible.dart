import 'package:flutter/material.dart';

///Animates visibility change by sliding the widget between offsets using
///SlideTransition.
class SlideVisible extends StatefulWidget {
  ///Whether or not this widget should be shown.
  ///
  ///The slide animation will play once when this field changes.
  final bool visible;

  ///The widget that is shown or hidden by this widget.
  final Widget child;

  ///The [Offset] of this widget when [visible] is false.
  ///
  ///Defaults to ```Offset(0, -1.1)```, which will slide the widget up by 
  ///slightly more than its height when the widget is hidden.
  final Offset hiddenOffset;

  ///The [Offset] of this widget when [visible] is true.
  ///
  ///Defaults to ```Offset(0,0)```.
  final Offset visibleOffset;

  ///The [Duration] of the slide animation.
  ///
  ///Defaults to ```300ms```.
  final Duration duration;

  ///The [Curve] that the slide animation will follow.
  ///
  ///Defaults to [Curves.linear]
  final Curve curve;

  SlideVisible({
    Key key,
    @required this.visible,
    @required this.child,
    this.hiddenOffset = const Offset(0, -1.1),
    this.visibleOffset = const Offset(0, 0),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  });

  @override
  _SlideVisibleState createState() => _SlideVisibleState();
}

class _SlideVisibleState extends State<SlideVisible>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation =
        Tween<Offset>(begin: widget.hiddenOffset, end: widget.visibleOffset)
            .animate(CurvedAnimation(
      curve: widget.curve,
      parent: _controller,
    ));

    //Ensure that the animation will not play if the widget starts as visible.
    if (widget.visible) {
      _controller.forward(from: _controller.upperBound);
    }
  }

  @override
  void didUpdateWidget(SlideVisible oldWidget) {
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
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}
