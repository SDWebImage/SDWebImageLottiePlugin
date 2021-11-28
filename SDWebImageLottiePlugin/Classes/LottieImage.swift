/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
import Lottie

/**
 * The asset bundle used for lottie animation to load bitmap images in the animation. If you don't provide this context option, use main bundle instead.
 * Defaults to nil, means main bundle. (NSBundle)
 */

extension SDWebImageContextOption{
    public static let lottieBundle : SDWebImageContextOption = SDWebImageContextOption(rawValue: "lottieBundle");
}

#if os(macOS)
public typealias PlatformImage = NSImage
#else
public typealias PlatformImage = UIImage
#endif

/// Used for Swift when subclassing UIImage, workaround for `required' initializer 'init(imageLiteralResourceName:)' must be provided by subclass of 'UIImage'`
extension PlatformImage {
    private convenience init!(failableImageLiteral name: String) {
        self.init(named: name)
    }
    
    public convenience init(imageLiteralResourceName name: String) {
        self.init(failableImageLiteral: name)
    }
}

/// A UIImage subclass wrapper for Lottie animation
public class LottieImage : PlatformImage, SDAnimatedImageProtocol {
    
    /// The lottie animation
    public var animation: Animation?
    
    public required init?(data: Data, scale: CGFloat, options: [SDImageCoderOption : Any]? = nil) {
        do {
            let animation = try JSONDecoder().decode(Animation.self, from: data)
            self.animation = animation
            self.animatedImageData = data
            // TODO: Lottie is like a vector animated format, but how to get Lottie's poster frame ?
            #if os(iOS) || os(tvOS)
            super.init()
            #else
            super.init(size: animation.size)
            #endif
        } catch let error {
            print(error)
            return nil
        }
    }
    
    #if os(iOS) || os(tvOS)
    public override var size: CGSize {
        if let animation = animation {
            return animation.size
        }
        return super.size
    }
    #endif
    
    public required convenience init?(animatedCoder: SDAnimatedImageCoder, scale: CGFloat) {
        guard let data = animatedCoder.animatedImageData else {
            return nil
        }
        self.init(data: data, scale: scale, options: nil)
    }
    
    #if os(iOS) || os(tvOS)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    #endif
    
    #if os(macOS)
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    #endif
    
    #if os(macOS)
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        super.init(pasteboardPropertyList: propertyList, ofType: type)
    }
    #endif
    
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
    
    public func animatedImageFrame(at index: UInt) -> PlatformImage? {
        return nil
    }
    
    public func animatedImageDuration(at index: UInt) -> TimeInterval {
        if let animation = animation {
            return animation.duration
        }
        return 0
    }
}
