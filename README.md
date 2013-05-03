FullScreenImageControl
======================

A Full Screen Image Control that allows you to pass a UIImageView as a parameter and then renders it as a full screen view. This is similar to the Facebook image control. Clicking on an image brings up a fullscreen image and also shows a "Done" button and other information. 

The biggest advantage of this control is that it supports both Portrait and Landscape orientation. This way, your app can be portrait only, but you can embed UIImageViews in them and register a tap recognizer to it. When clicked, simply call the control in this project and you have a full-screen rendition of your image with support for device rotation.


Requirements
------------

FullScreenImageControl needs ARC. Other than that, it should work on any iOS version.

Adding to your project
----------------------
