/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import <SDWebImage/SDWebImage.h>
#import <Lottie/Lottie.h>

/**
 * The asset bundle used for lottie animation to load bitmap images in the animation. If you don't provide this context option, use main bundle instead.
 * Defaults to nil, means main bundle. (NSBundle)
 */
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const SDWebImageContextLottieBundle;

/**
 A wrapper class to allow `LOTComposition` to be compatible for SDWebImage loading/cache/rendering system. The lottie json loading from `LOTCompositionView+WebCache` category, will use this subclass instead of `UIImage`.

 @note Though this class conforms to `SDAnimatedImage` protocol, so it's compatible to be used for `SDAnimatedImageView`. But it's normally discouraged to do so. Because it does not provide optimization for animation rendering. Instead, use `SDAnimatedImage` class with `SDAnimatedImageView`.
 @note If you want to get the bitmap version of Lottie animation at specify frame, call `animatedImageFrameAtIndex:` will result a snapshot for frame.
*/
@interface LOTAnimatedImage : UIImage <SDAnimatedImage>

/**
 The `LOTComposition` instance for Lottie representation. This property typically be nonnull if you init the image with the following methods. However, it will be null when you call super method like `initWithCGImage:`
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
