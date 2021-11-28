/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
import Lottie

#if os(iOS) || os(tvOS)
/// These code is from https://github.com/airbnb/lottie-ios/pull/1123/files
extension CompatibleAnimationView {
    @objc
    public var animationView: AnimationView {
        self.subviews.first as! AnimationView
    }
    
    @objc
    public var isAnimationPlaying: Bool {
      return animationView.isAnimationPlaying
    }
    
    @objc
    public var animationDuration: TimeInterval {
      return animationView.animation?.duration ?? -1;
    }
    
    @objc
    public func setFloatValue(_ value: CGFloat, forKeypath keypath: CompatibleAnimationKeypath) {

      let valueProvider = FloatValueProvider(value)
      animationView.setValueProvider(valueProvider, keypath: keypath.animationKeypath)
    }

    @objc
    public func getFloatValue(for keypath: CompatibleAnimationKeypath, atFrame: CGFloat) -> NSNumber? {
      let value = animationView.getValue(for: keypath.animationKeypath, atFrame: atFrame)
      return value as? NSNumber
    }
    
    @objc
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
      return animationView.intrinsicContentSize
    }

    @objc
    public override var intrinsicContentSize: CGSize {
      get { return animationView.intrinsicContentSize }
    }
}

extension CompatibleAnimationView {
    /**
     * Set the imageView `image` with an `url`, placeholder, custom options and context.
     *
     * The download is asynchronous and cached.
     *
     * @param url            The url for the image.
     * @param placeholder    The image to be set initially, until the image request finishes.
     * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
     * @param context        A context contains different options to perform specify changes or processes, see `SDWebImageContextOption`. This hold the extra objects which `options` enum can not hold.
     * @param progressBlock  A block called while image is downloading
     *                       @note the progress block is executed on a background queue
     * @param completedBlock A block called when operation has been completed. This block has no return value
     *                       and takes the requested UIImage as first parameter. In case of error the image parameter
     *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
     *                       indicating if the image was retrieved from the local cache or from the network.
     *                       The fourth parameter is the original image url.
     * Note: If your Lottie json files contains references to App bundle images, you can use `.lottieBundle` context option to pass the NSBundle object to load it.
     */
    @objc
    public func sd_setImage(with url: URL?, placeholderImage placeholder: UIImage? = nil, options: SDWebImageOptions = [], context: [SDWebImageContextOption : Any]? = nil, progress progressBlock: SDImageLoaderProgressBlock? = nil, completed completedBlock: SDExternalCompletionBlock? = nil) {
        var context = context ?? [:]
        context[.animatedImageClass] = LottieImage.self
        self.sd_internalSetImage(with: url, placeholderImage: placeholder, options: options, context: context, setImageBlock: { [weak self] (image, data, cacheType, url) in
            if let lottieImage = image as? LottieImage {
                self?.animationView.animation = lottieImage.animation
                if let bundle = context[.lottieBundle] as? Bundle{
                    let imageProvider = BundleImageProvider(bundle: bundle, searchPath: "")
                    self?.animationView.imageProvider = imageProvider
                }
            } else {
                self?.animationView.animation = nil
            }
        }, progress: progressBlock) { (image, data, error, cacheType, finiseh, url) in
            completedBlock?(image, error, cacheType, url)
        }
    }
}
#endif
