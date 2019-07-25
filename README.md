# animated_visibility_widgets

The this package provides simple wrappers around common "XTransition" widgets in Flutter. The goal is to simplify the creation of state-based transition animations without the need to create and call methods on Flutter's ```AnimationController```.

Currently this package provides four widgets that wrap Flutter's ```FadeTransition```, ```ScaleTransition```, ```SlideTransition```, and ```SizeTransition``` widgets, all of which expose a boolean ```visibility``` property that will play the associated transition animation whenever it switches between ```true``` and ```false```.

## But why?
Good question! 

Flutter's declarative programming style works extremely well for building a UI and populating it with data, allowing changes in the data state to update the UI state automatically. It's very easy to tell the framework that, in terms of the UI, you would like something to _be different_ based on the state. However it is less straightforward to tell the framework that you would like something to __happen__ based on the state.

As an example, let's say we're using a ```StreamBuilder```, and we want different widgets to be visible based on the state of the stream. If the stream has no data, a widget with a loading indicator should slide into view, and, importantly, should slide back out of view when the stream has data.

The common way to handle loading states for streams is something like the following:

```dart
Widget build(context) {
  return StreamBuilder(
    stream: _dataStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return LoadingWidget()
      }
      return DataWidget(data: snapshot.data);
    }
  );
}
```

This will cause the screen to transition completely between one widget and the other when the status of the snapshot data changes. However, let's say that we actually want to have the Loading widget sit on top of the DataWidget when the stream has no data, either because the DataWidget still has some interactivity even when it doesn't have stream data, or because we just like the look of a floating progress indicator. We might do something like this:

```dart
Widget build(context) {
  StreamBuilder(
    stream: _dataStream,
    builder: (context, snapshot) {
      return Stack(children: <Widget>[
        //Here we assume the DataWidget can handle a null value
        DataWidget(data: snapshot.data),
        if (!snapshot.hasData) LoadingWidget()
      ]);
    }
  );
}
```

Okay, so now our LoadingWidget sits on top of the DataWidget when the stream has no data, but rather than just appearing on top, we want it to slide in from the top of the screen. There are several ways to do this, but the most straightforward might be to use either a ```SlideTransition``` widget, or an ```AnimatedPositioned``` widget. Both have some drawbacks in this scenario.

The ```SlideTransition``` widget requires that it be provided with an ```AnimationController```, which much be checked and controlled from somewhere within the ```build``` method.

```dart
class ParentWidget extends StatefulWidget {
  createState() => ParentWidgetState();
}
class ParentWidgetState extends State<ParentWidget>
  with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _slideAnimation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData && _controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        } else if (snapshot.hasData && _controller.status == AnimationStatus.completed) {
          _controller.reverse();
        }
        return Stack(children: <Widget>[
          DataWidget(data: snapshot.data),
          SlideTransition(
            position: _slideAnimation,
            child: LoadingWidget(),
          )
        ]);
      }
    );
  }
}
```
This introduces a lot of extra code and, more importantly, our ```build``` method is suddenly beset by a big block of imperative code nestled uncomfortably amist all of our nice declarative UI code. It only gets worse if there are several overlay widgets that are animated based on various aspects of the stream state.

Alright then, let's see if we can do better with ```AnimatedPositioned```.

```dart
class ParentWidget extends StatelessWidget {

  double loadingWidgetHeight = 50;
  double hiddenOvershoot = 10;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: _dataStream,
      builder: (context, snapshot) {
        return Stack(children: <Widget>[
          DataWidget(data: snapshot.data),
          AnimatedPositioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: snapshot.hasData 
              ? screenSize.height + hiddenOvershoot 
              : screenSize.height - loadingWidgetHeight,
            child: LoadingWidget(),
          )
        ]);
      }
    );
  }
}
```

Not too bad, and certainly not the only way to achieve this effect with ```AnimatedPositioned```, but there are still some drawbacks. First, the ```AnimatedPositioned``` widget MUST be a child of a ```Stack```. Second, we lose the handy ```Offset``` parameter that makes the ```SlideTransition``` so easy to use. We have to work with the screensize and an explicit container size in order to know where we should tell the ```AnimatedPositioned``` widget to put itself.

## Using this package

Now we will use ```SlideVisible``` from this package to accomplish the same goal as above.

```dart
class ParentWidget extends StatlessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (context, snapshot) {
        return Stack(children: <Widget>[
          DataWidget(),
          Align(
            alignment: Alignment.topCenter,
            child: SlideVisible(
              visible: !snapshot.hasData,
              hiddenOffset: const Offset(0, -1.1),
              child: LoadingWidget(),
            )
          ),
        ]);
      }
    )
  }
}
```
Everything about the widget and the animation is contained in one place, and all we have to do is tell it whether or not it should currently be ```visible```. We can change the ```hiddenOffset``` to control the direction from which it enters and exits the screen, and we don't have to worry too much about the size of the widget itself, or mess around with ```AnimationControllers``` to get them to agree with our state. 

Optionally we can pass in a ```Duration``` and/or a ```Curve``` for finer control of the animation, and this information is situated within the widget declaration, rather than in the ```initState``` method elsewhere in the parent widget class.

For more information, please see the examples and documentation.