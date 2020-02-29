# SDWebImageLottiePlugin

[![CI Status](https://img.shields.io/travis/SDWebImage/SDWebImageLottiePlugin.svg?style=flat)](https://travis-ci.org/SDWebImage/SDWebImageLottiePlugin)
[![Version](https://img.shields.io/cocoapods/v/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![License](https://img.shields.io/cocoapods/l/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![Platform](https://img.shields.io/cocoapods/p/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/SDWebImage/SDWebImageLottiePlugin)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![codecov](https://codecov.io/gh/SDWebImage/SDWebImageLottiePlugin/branch/master/graph/badge.svg)](https://codecov.io/gh/SDWebImage/SDWebImageLottiePlugin)

## What's for
SDWebImageLottiePlugin is a plugin for [SDWebImage](https://github.com/rs/SDWebImage/) framework, which provide the [Lottie](https://github.com/airbnb/lottie-ios) animation loading from JSON file.

You can find more resource about about Lottie in their [Oficial Site](https://airbnb.design/lottie/).

## Requirements

+ iOS 9+
+ macOS 10.10+
+ tvOS 9+
+ Xcode 11+
+ Swift 5

## Installation

#### CocoaPods

SDWebImageLottiePlugin is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SDWebImageLottiePlugin'
```

#### Carthage

SDWebImageLottiePlugin is available through [Carthage](https://github.com/Carthage/Carthage).

```
github "SDWebImage/SDWebImageLottiePlugin"
```

#### Swift Package Manager (Xcode 11+)

SDWebImageLottiePlugin is available through [Swift Package Manager](https://swift.org/package-manager).

Note: SwiftPM support iOS only, on tvOS && macOS support. If you want, ask Lottie community to add support to these platforms.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageLottiePlugin.git", from: "0.1")
    ]
)
```

## Usage

+ Swift

```swift
let animationView: AnimationView
let lottieJSONURL: URL
animationView.sd_setImage(with: lottieJSONURL)
```

+ Objective-C

Note: Lottie 3.0 was rewritten with Swift, but there are still one compatible view left for Objective-C. Learn more here: http://airbnb.io/lottie/#/ios-migration

```objective-c
CompatibleAnimationView *animationView;
NSURL *lottieJSONURL;
[animationView sd_setImageWithURL:lottieJSONURL];
```

## Demo

If you have some issue about usage, SDWebImageLottiePlugin provide a demo for iOS && macOS platform. To run the demo, clone the repo and run the following command.

```bash
cd Example/
pod install
open SDWebImageLottiePlugin.xcworkspace
```

After the Xcode project was opened, click `Run` to build and run the demo.

## Screenshot

<img src="https://raw.githubusercontent.com/SDWebImage/SDWebImageLottiePlugin/master/Example/Screenshot/LottieDemo.gif" width="300" />

The lottie json is from [lottie-web example](https://github.com/airbnb/lottie-web/tree/master/demo/gatin)

## Author

DreamPiggy

## License

SDWebImageLottiePlugin is available under the MIT license. See the LICENSE file for more info.
