/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
import Lottie

extension AnimationView {
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
     */
    public func sd_setImage(with url: URL?, placeholderImage placeholder: PlatformImage? = nil, options: SDWebImageOptions = [], context: [SDWebImageContextOption : Any]? = nil, progress progressBlock: SDImageLoaderProgressBlock? = nil, completed completedBlock: SDExternalCompletionBlock? = nil) {
        var context = context ?? [:]
        context[.animatedImageClass] = LottieImage.self
        self.sd_internalSetImage(with: url, placeholderImage: placeholder, options: options, context: context, setImageBlock: { [weak self] (image, data, cacheType, url) in
            if let lottieImage = image as? LottieImage {
                self?.animation = lottieImage.animation
            } else {
                self?.animation = nil
            }
        }, progress: progressBlock) { (image, data, error, cacheType, finiseh, url) in
            completedBlock?(image, error, cacheType, url)
        }
    }
}
