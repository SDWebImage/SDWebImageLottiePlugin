//
//  LOTAnimatedImage.m
//  SDWebImageLottiePlugin
//
//  Created by 李卓立 on 2020/3/1.
//  Copyright © 2020 cocoapods. All rights reserved.
//

#import "LOTAnimatedImage.h"
#undef UIColor
#import "LOTCompositionContainer.h"

@interface LOTAnimatedImage ()

@property (nonatomic, copy, nullable) NSData *animatedImageData;
@property (nonatomic, strong, nullable) LOTCompositionContainer *compositionContainer;

@end

@implementation LOTAnimatedImage

- (instancetype)initWithComposition:(LOTComposition *)composition {
#if SD_UIKIT
    self = [super init];
#else
    self = [super initWithSize:composition.compBounds.size];
#endif
    if (self) {
        _composition = composition;
        _animatedImageData = nil;
    }
    return self;
}

+ (instancetype)imageWithContentsOfFile:(NSString *)path {
    return [[self alloc] initWithContentsOfFile:path];
}

+ (instancetype)imageWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)imageWithData:(NSData *)data scale:(CGFloat)scale {
    return [[self alloc] initWithData:data scale:scale];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data scale:1];
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self initWithData:data];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale {
    return [self initWithData:data scale:scale options:nil];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale options:(SDImageCoderOptions *)options {
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    if (![jsonObject isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    LOTComposition *composition = [LOTComposition animationFromJSON:jsonObject];
    if (!composition) {
        return nil;
    }
#if SD_UIKIT
    self = [super init];
#else
    self = [super initWithSize:composition.compBounds.size];
#endif
    if (self) {
        _composition = composition;
        _animatedImageData = data;
    }
    return self;
}

- (instancetype)initWithAnimatedCoder:(id<SDAnimatedImageCoder>)animatedCoder scale:(CGFloat)scale {
    // Does not support progressive load for Lottie images at all
    return nil;
}

#if SD_UIKIT
- (CGSize)size {
    LOTComposition *composition = self.composition;
    if (composition) {
        return composition.compBounds.size;
    }
    return [super size];
}
#endif

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSData *animatedImageData = [aDecoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(animatedImageData))];
        if (!animatedImageData) {
            return self;
        }
        NSError *error;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:animatedImageData options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
        LOTComposition *composition = [LOTComposition animationFromJSON:jsonObject];
        if (!composition) {
            return nil;
        }
        _composition = composition;
        _animatedImageData = animatedImageData;
#if SD_MAC
        self.size = composition.compBounds.size;
#endif
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    NSData *animatedImageData = self.animatedImageData;
    if (animatedImageData) {
        [aCoder encodeObject:animatedImageData forKey:NSStringFromSelector(@selector(animatedImageData))];
    }
}

#pragma mark - Helper

- (LOTCompositionContainer *)compositionContainer {
    if (!_compositionContainer) {
        _compositionContainer = [[LOTCompositionContainer alloc] initWithModel:nil inLayerGroup:nil withLayerGroup:self.composition.layerGroup withAssestGroup:self.composition.assetGroup];
    }
    return _compositionContainer;
}

- (UIImage *)createFrameWithComposition:(nonnull LOTComposition *)composition frameIndex:(NSUInteger)frameIndex {
    LOTCompositionContainer *container = self.compositionContainer;
    if (!container) {
        return nil;
    }
    [container displayWithFrame:@(frameIndex) forceUpdate:YES];
    SDGraphicsImageRenderer *renderer = [[SDGraphicsImageRenderer alloc] initWithSize:composition.compBounds.size];
    UIImage *image = [renderer imageWithActions:^(CGContextRef  _Nonnull context) {
        [container renderInContext:context];
    }];
    return image;
}

#pragma mark - SDAnimatedImage

- (UIImage *)animatedImageFrameAtIndex:(NSUInteger)index {
    LOTComposition *composition = self.composition;
    if (!composition) {
        return nil;
    }
    UIImage *frame = [self createFrameWithComposition:composition frameIndex:index];
    return frame;
}

- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index {
    LOTComposition *composition = self.composition;
    if (!composition) {
        return 0;
    }
    NSUInteger frameCount = self.animatedImageFrameCount;
    if (frameCount == 0) {
        return 0;
    }
    return composition.timeDuration / frameCount;
}

- (NSUInteger)animatedImageLoopCount {
    return 0;
}

- (NSUInteger)animatedImageFrameCount {
    LOTComposition *composition = self.composition;
    if (!composition) {
        return 0;
    }
    return (composition.endFrame.unsignedIntegerValue - composition.startFrame.unsignedIntegerValue);
}

@end