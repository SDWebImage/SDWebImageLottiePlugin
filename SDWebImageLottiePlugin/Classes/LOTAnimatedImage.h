//
//  LOTAnimatedImage.h
//  SDWebImageLottiePlugin
//
//  Created by 李卓立 on 2020/3/1.
//  Copyright © 2020 cocoapods. All rights reserved.
//

#import <SDWebImage/SDWebImage.h>
#import <Lottie/Lottie.h>

/**
 A wrapper class to allow `LOTComposition` to be compatible for SDWebImage loading/cache/rendering system. The `GIF` image loading from `LOTCompositionView+WebCache` category, will use this subclass instead of `UIImage`.

 @note Though this class conforms to `SDAnimatedImage` protocol, so it's compatible to be used for `SDAnimatedImageView`. But it's normally discouraged to do so. Because it does not provide optimization for animation rendering. Instead, use `SDAnimatedImage` class with `SDAnimatedImageView`.
 @note If you want to get the bitmap version of Lottie animation at specify frame, call `animatedImageFrameAtIndex:` will result a snapshot for frame.
*/
@interface LOTAnimatedImage : UIImage <SDAnimatedImage>

/**
 The `LOTComposition` instance for Lottie representation.
*/
@property (nonatomic, strong, readonly, nullable) LOTComposition *composition;

/**
 Create the wrapper with specify `LOTComposition` instance. The instance should be nonnull.
 This is a convenience method for some use cases, for example, create a placeholder with `LOTComposition`.
 @param composition The `LOTComposition` instance
 @return An initialized object
*/
- (nonnull instancetype)initWithComposition:(nonnull LOTComposition *)composition;

// This class override these methods from UIImage, and it supports NSSecureCoding.
// You should use these methods to create a new animated image. Use other methods just call super instead.
+ (nullable instancetype)imageWithContentsOfFile:(nonnull NSString *)path;
+ (nullable instancetype)imageWithData:(nonnull NSData *)data;
+ (nullable instancetype)imageWithData:(nonnull NSData *)data scale:(CGFloat)scale;
- (nullable instancetype)initWithContentsOfFile:(nonnull NSString *)path;
- (nullable instancetype)initWithData:(nonnull NSData *)data;
- (nullable instancetype)initWithData:(nonnull NSData *)data scale:(CGFloat)scale;

@end
