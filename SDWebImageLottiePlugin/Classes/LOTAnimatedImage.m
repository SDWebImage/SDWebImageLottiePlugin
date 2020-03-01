//
//  LOTAnimatedImage.m
//  SDWebImageLottiePlugin
//
//  Created by 李卓立 on 2020/3/1.
//  Copyright © 2020 cocoapods. All rights reserved.
//

#import "LOTAnimatedImage.h"

@interface LOTAnimatedImage ()

@property (nonatomic, copy, nullable) NSData *animatedImageData;

@end

@implementation LOTAnimatedImage

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
    NSData *data = animatedCoder.animatedImageData;
    if (!data) {
        return nil;
    }
    return [self initWithData:data scale:scale options:nil];
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

#pragma mark - SDAnimatedImage

- (UIImage *)animatedImageFrameAtIndex:(NSUInteger)index {
    return nil;
}

- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index {
    LOTComposition *composition = self.composition;
    if (!composition) {
        return 0;
    }
    return composition.timeDuration;
}

- (NSUInteger)animatedImageLoopCount {
    return 0;
}

- (NSUInteger)animatedImageFrameCount {
    LOTComposition *composition = self.composition;
    if (!composition) {
        return 0;
    }
    return (composition.endFrame.doubleValue - composition.startFrame.doubleValue) * composition.framerate.doubleValue;
}

@end
