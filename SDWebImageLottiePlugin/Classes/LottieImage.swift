/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
@testable import Lottie

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
    
    /// The lottie animation model
    public var animation: Animation?
    
    /// Init the LottieImage with lottie animation model
    /// - Parameter animation: animation
    public required init?(animation: Animation) {
        #if os(iOS) || os(tvOS)
        super.init()
        #else
        super.init(size: animation.size)
        #endif
        self.animation = animation
    }
    
    public required init?(data: Data, scale: CGFloat, options: [SDImageCoderOption : Any]? = nil) {
        let animation: Animation
        do {
            animation = try JSONDecoder().decode(Animation.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
        #if os(iOS) || os(tvOS)
        super.init()
        #else
        super.init(size: animation.size)
        #endif
        self.animation = animation
        self.animatedImageData = data
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
    
    //MARK: - NSSecureCoding
    #if os(iOS) || os(tvOS)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        decode(with: coder)
    }
    #endif
    
    #if os(macOS)
    required public init(coder: NSCoder) {
        // Hack: Why NSImage on AppKit use another non-optional NSCoding ?
        super.init(coder: coder)
        decode(with: coder)
    }
    #endif
    
    private func decode(with coder: NSCoder) {
        if let data = coder.decodeObject(of: NSData.self, forKey: "animatedImageData") as? Data {
            let animation: Animation
            do {
                animation = try JSONDecoder().decode(Animation.self, from: data)
            } catch let error {
                print(error)
                return
            }
            self.animation = animation
            self.animatedImageData = data
            #if os(macOS)
            self.size = animation.size
            #endif
        }
    }
    
    public override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        if let animatedImageData = animatedImageData {
            coder.encode(animatedImageData, forKey: "animatedImageData")
        }
    }
    
    #if os(macOS)
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        super.init(pasteboardPropertyList: propertyList, ofType: type)
    }
    #endif
    
    // MARK: - Helper
    lazy var compositionLayer: LottieCompositionLayer? = {
        guard let animation = animation else {
            return nil
        }
        let compositionLayer = LottieCompositionLayer(animation: animation)
        return compositionLayer
    }()
    
    func createFrame(with animation: Animation, frameIndex: UInt) -> PlatformImage? {
        // We use AnimationFrameTime(Seconds * Framerate) as frame count, so this is 1:1 mapping
        let frame = CGFloat(frameIndex)
        guard let compositionLayer = compositionLayer else {
            return nil
        }
        compositionLayer.displayWithFrame(frame: frame, forceUpdates: true)
        let renderer = SDGraphicsImageRenderer(size: animation.size)
        let image = renderer.image { context in
            // Render CALayer for current frame
            compositionLayer.render(in: context)
        }
        return image
    }
    
    // MARK: - SDAnimatedImageProvider
    public private(set) var animatedImageData: Data?
    
    public var animatedImageFrameCount: UInt {
        guard let animation = animation else {
            return 0
        }
        return UInt(animation.endFrame - animation.startFrame)
    }
    
    public var animatedImageLoopCount: UInt {
        return 0
    }
    
    public func animatedImageFrame(at index: UInt) -> PlatformImage? {
        guard let animation = animation else {
            return nil
        }
        let image = createFrame(with: animation, frameIndex: index)
        return image
    }
    
    public func animatedImageDuration(at index: UInt) -> TimeInterval {
        guard let animation = animation else {
            return 0
        }
        let frameCount = self.animatedImageFrameCount
        if frameCount == 0 {
            return 0
        }
        return animation.duration / Double(frameCount)
    }
}
