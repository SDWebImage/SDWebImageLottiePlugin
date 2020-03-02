# SDWebImageLottiePlugin

[![CI Status](https://img.shields.io/travis/SDWebImage/SDWebImageLottiePlugin.svg?style=flat)](https://travis-ci.org/SDWebImage/SDWebImageLottiePlugin)
[![Version](https://img.shields.io/cocoapods/v/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![License](https://img.shields.io/cocoapods/l/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![Platform](https://img.shields.io/cocoapods/p/SDWebImageLottiePlugin.svg?style=flat)](https://cocoapods.org/pods/SDWebImageLottiePlugin)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/SDWebImage/SDWebImageLottiePlugin)
[![codecov](https://codecov.io/gh/SDWebImage/SDWebImageLottiePlugin/branch/master/graph/badge.svg)](https://codecov.io/gh/SDWebImage/SDWebImageLottiePlugin)

## What's for
SDWebImageLottiePlugin is a plugin for [SDWebImage](https://github.com/rs/SDWebImage/) framework, which provide the [Lottie](https://github.com/airbnb/lottie-ios) animation loading from JSON file.

You can find more resource about Lottie in their [Official Site](https://airbnb.design/lottie/).

## Requirements

+ iOS 8+
+ macOS 10.10+
+ tvOS 9+
+ Xcode 11+

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

## Lottie 2 && 3

Although Lottie already release 3.x with the full Swift-rewritten code, however, during the performance testing of demo project, the Lottie 3 render performance is 60% slower than Lottie 2, many animation can not render as 60 FPS, while Lottie 2 did. See compare result at [here](https://github.com/SDWebImage/SDWebImageLottiePlugin/issues/1).

So, to provide better performance on user, this plugin was written to support Lottie 2 currently, until Lottie community fix the performance problem. Track the issue [here](https://github.com/airbnb/lottie-ios/issues/895).

If you really want Lottie 3 support, please checkout [1.x branch](https://github.com/SDWebImage/SDWebImageLottiePlugin/tree/1.x), which provide the Lottie 3 and fully written in Swift. Once Lottie 3 fix the performance issue, we will upgrade this plugin's major version to 1.0 and release with Lottie 3 support.

## Usage

### Load Lottie from remote JSON

+ Objective-C

```objective-c
LOTAnimationView *animationView;
NSURL *lottieJSONURL;
[animationView sd_setImageWithURL:lottieJSONURL];
```

+ Swift

```swift
let animationView: LOTAnimationView
let lottieJSONURL: URL
animationView.sd_setImage(with: lottieJSONURL)
```

Note:
+ You can also load lottie json files on `LOTAnimatedControl`, like switch button.
+ Lottie animation does not start automatically, you can use the completion block, or UITableView/UICollectionView's will display timing to play.
+ If your Lottie json files contains references to App bundle images, you can use `SDWebImageContextLottieBundle` context option to pass the NSBundle object to load it.

### Advanced usage

This Lottie plugin use a wrapper class `LOTAnimatedImage` because of SDWebImage's [customization architecture design](https://github.com/SDWebImage/SDWebImage/wiki/Advanced-Usage#customization). Typically you should not care about this, however this can allows some advanced usage.

+ Objective-C

```objective-c
LOTComposition *composition = [LOTComposition animationFromJSON:jsonDict];
LOTAnimatedImage *animatedImage = [[LOTAnimationImage alloc] initWithComposition:composition];
// Snapshot Lottie animation frame
UIImage *posterFrame = [animatedImage animatedImageAtIndex:0];
```

+ Swift

```swift
let composition = LOTComposition(json: jsonDict)
let animatedImage = LOTAnimationImage(composition: composition)
// Snapshot Lottie animation frame
UIImage *posterFrame = animatedImage.animatedImageFrame(at: 0)
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

+ iOS Demo

<img src="https://raw.githubusercontent.com/SDWebImage/SDWebImageLottiePlugin/master/Example/Screenshot/LottieDemo.gif" width="300" />

+ macOS Demo

<img src="https://raw.githubusercontent.com/SDWebImage/SDWebImageLottiePlugin/master/Example/Screenshot/LottieDemo-macOS.gif" width="300" />

The lottie json files are from [lottie-web example](https://github.com/airbnb/lottie-web)

## Author

DreamPiggy

## License

SDWebImageLottiePlugin is available under the MIT license. See the LICENSE file for more info.
