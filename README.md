# AGVolumeControlView

  We’re happy to introduce you a new free regulator AGVolumeControlView based on our lightweight open-source visual component that doesn't require extra lines of code and can be easily integrated into your project.
Visual regulator can be connected to a player or other smart house’s device making the process of controlling the level of a particular characteristic much easier.

[![CI Status](http://img.shields.io/travis/liptugamichael@gmail.com/AGVolumeControlView.svg?style=flat)](https://travis-ci.org/liptugamichael@gmail.com/AGVolumeControlView)
[![Version](https://img.shields.io/cocoapods/v/AGVolumeControlView.svg?style=flat)](http://cocoapods.org/pods/AGVolumeControlView)
[![License](https://img.shields.io/cocoapods/l/AGVolumeControlView.svg?style=flat)](http://cocoapods.org/pods/AGVolumeControlView)
[![Platform](https://img.shields.io/cocoapods/p/AGVolumeControlView.svg?style=flat)](http://cocoapods.org/pods/AGVolumeControlView)

## Installation

AGVolumeControlView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AGVolumeControlView"
```

## Demo

<img src="https://user-images.githubusercontent.com/4165054/26985499-5b9356c4-4d4c-11e7-8a6c-d61953558ebf.gif" alt="VolumeControlView Demo" height="420" width="260" border ="50">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
You can also see an example :

Just bind AGVolumeControl as outlet to your ViewController:

````swift

@IBOutlet weak var volumeControl: AGVolumeControl!

````

And start playing your control. AGVolumeControl is a regulator of any controllable parameter, such as the volume, brightness, speed, etc.

````swift

self.startPlay()

````

The visual display of this regulator can be easily customized. One has a possibility to choose colors, the gradient style and background according to the wishes:

````swift

    open var thumbRadius: CGFloat
    
    open var customBackgroundColor : UIColor
    
    open var volumeControlSliderColor : UIColor
    
    open var decibelsLevel : CGFloat
    
    open var hueStart : CGFloat
    
    open var hueEnd : CGFloat

    open var minimumValue: CGFloat

    open var maximumValue: CGFloat
    
    open var thumbColor: UIColor
    
    open var gradientMaskColor: UIColor
````

## Troubleshooting
Problems? Check the [Issues](https://github.com/agilie/AGVolumeControlView/issues) block
to find the solution or create an new issue that we will fix asap. Feel free to contribute.


## Author
This iOS visual component is open-sourced by [Agilie Team](https://www.agilie.com) <info@agilie.com>


## Contributors
- [Michael Liptuga](https://github.com/Liptuga-Michael)


## Contact us
<ios@agilie.com>

## License

AGVolumeControlView is available under
The [MIT](LICENSE.md) License (MIT) Copyright © 2017 [Agilie Team](https://www.agilie.com) 
