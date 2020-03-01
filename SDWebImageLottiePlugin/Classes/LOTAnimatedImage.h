//
//  LOTAnimatedImage.h
//  SDWebImageLottiePlugin
//
//  Created by 李卓立 on 2020/3/1.
//  Copyright © 2020 cocoapods. All rights reserved.
//

#import <SDWebImage/SDWebImage.h>
#import <Lottie/Lottie.h>

@interface LOTAnimatedImage : UIImage <SDAnimatedImage>

@property (nonatomic, strong, readonly, nullable) LOTComposition *composition;

@end
