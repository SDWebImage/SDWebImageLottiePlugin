/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
@testable import Lottie


/// This layer is used if as Lottie 2's`LOTCompositionContainer`.
/// Which can render the specify frame into CGBitmapContext, used for debugging or some snapshot use case
class LottieCompositionLayer : CALayer {
    var animationLayers: [CompositionLayer]?
    init(animation: Animation) {
        let layerImageProvider = LayerImageProvider(imageProvider: BundleImageProvider(bundle: .main, searchPath: nil).cachedImageProvider, assets: animation.assetLibrary?.imageAssets)
        let layers = animation.layers.initializeCompositionLayers(assetLibrary: animation.assetLibrary, layerImageProvider: layerImageProvider, textProvider: DefaultTextProvider(), fontProvider: DefaultFontProvider(), frameRate: CGFloat(animation.framerate))
        super.init()
        bounds = animation.bounds
        
        for layer in layers.reversed() {
            layer.bounds = bounds
            addSublayer(layer)
        }
        animationLayers = layers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayWithFrame(frame: CGFloat, forceUpdates: Bool) {
        animationLayers?.forEach { $0.displayWithFrame(frame: frame, forceUpdates: forceUpdates) }
    }
}
