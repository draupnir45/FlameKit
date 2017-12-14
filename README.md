# FlameKit

[![Version](https://img.shields.io/cocoapods/v/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![License](https://img.shields.io/cocoapods/l/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![Platform](https://img.shields.io/cocoapods/p/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)

한글 설명은 [여기](README_Kor.md)

## Summary

FlameKit is collection of simple custom UIs. For version 0.1.0, It offers three Classes. FlameNavigationBar, FlameScrollView & FlameButton. 

#### FlameNavigationBar
FlameNavigationBar is UIView-based customizable NavigationBar. FlameNavigationBar supports iOS 11 style LargeTitle and collapsing. It's compatible with scrollview. (FlameNavigationBar will be a delegate of scrollView... It will be fixed in future update.)

#### FlameScrollView
FlameScrollView is subclass of UIScrollView which has UIStackView(vertical) as a built-in subview. It's seats somewhere between UIScrollView and UITableView. If you want to add vertical stack simply call addArrangedSubview(_:animated:horizontalInset:height:) to the instance of FlameScrollView. FlameScrollView also automatically listen to the keyboard show/hide notification.

#### FlameButton
FlameButton is UIView-based button that uses closure, not selector.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 4.0 +
- iOS 9.0 +

## Installation

FlameKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FlameKit'
```

## Author

Jongchan Mark Park, draupnir45@gmail.com

## License

FlameKit is available under the MIT license. See the LICENSE file for more info.
