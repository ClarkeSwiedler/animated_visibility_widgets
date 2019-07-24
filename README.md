# animated_visibility_widgets

The purpose of this package is to provide simple wrappers around common "XTransition" widgets in Flutter. The goal is to simplify the creation of state-based transition animations without the need to create and call methods on Flutter's ```AnimationController```.

Currently this package provides four widgets that wrap Flutter's ```FadeTransition```, ```ScaleTransition```, ```SlideTransition```, and ```SizeTransition``` widgets, all of which expose a boolean ```visibility``` property that will play the associated transition animation whenever it switches between ```true``` and ```false```.

## But why?
Good question! 

Flutter's declarative programming style works extremely well for building a UI and populating it with data, allowing changes in the data state to update the UI state automatically. It's very easy to tell the framework that, in terms of the UI, you would like something to _be different_ based on the state. However it is less straightforward to tell the framework that you would like something to __happen__ based on the state.