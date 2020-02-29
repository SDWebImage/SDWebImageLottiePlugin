//
//  LottieImage.swift
//  SDWebImageLottiePlugin
//
//  Created by 李卓立 on 2020/2/28.
//

import SDWebImage
import Lottie

extension UIImage : _ExpressibleByImageLiteral {
    private convenience init!(failableImageLiteral name: String) {
        self.init(named: name)
    }
    
    public convenience init(imageLiteralResourceName name: String) {
        self.init(failableImageLiteral: name)
    }
}

public class LottieImage : UIImage, SDAnimatedImageProtocol {
    public var animation: Animation?
    
    public required init?(data: Data, scale: CGFloat, options: [SDImageCoderOption : Any]? = nil) {
        do {
            let animation = try JSONDecoder().decode(Animation.self, from: data)
            self.animation = animation
            self.animatedImageData = data
            // TODO: Lottie is like a vector animated format, but how to get Lottie's poster frame ?
            super.init()
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public override var size: CGSize {
        if let animation = animation {
            return animation.size
        }
        return super.size
    }
    
    public required convenience init?(animatedCoder: SDAnimatedImageCoder, scale: CGFloat) {
        guard let data = animatedCoder.animatedImageData else {
            return nil
        }
        self.init(data: data, scale: scale, options: nil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: SDAnimatedImageProvider
    public private(set) var animatedImageData: Data?
    
    public var animatedImageFrameCount: UInt {
        if let animation = animation {
            return UInt((animation.endFrame - animation.startFrame) * CGFloat(animation.framerate))
        }
        return 0
    }
    
    public var animatedImageLoopCount: UInt {
        return 0
    }
    
    public func animatedImageFrame(at index: UInt) -> UIImage? {
        return nil
    }
    
    public func animatedImageDuration(at index: UInt) -> TimeInterval {
        if let animation = animation {
            return animation.duration
        }
        return 0
    }
}
