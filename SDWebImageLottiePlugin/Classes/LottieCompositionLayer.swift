/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SDWebImage
@testable import Lottie

/// This layer is used like Lottie 2's`LOTCompositionContainer`. Typically private, use with caution :)
/// Which can render the specify frame into CGBitmapContext by calling `layer.render(in:)`, used for debugging or some snapshot use case
public class LottieCompositionLayer : CALayer {
    
    /// All composition sublayers, in hierarchy (reverse order) unlike `sublayers`
    private var animationLayers: [CompositionLayer] = []
    
    /// Initializes an LottieCompositionLayer with an animation.
    /// - Parameters:
    ///   - animation: animation
    ///   - imageProvider: imageProvider
    ///   - textProvider: textProvider
    ///   - fontProvider: fontProvider
    public init(animation: Animation,
                imageProvider: AnimationImageProvider? = nil,
                textProvider: AnimationTextProvider? = nil,
                fontProvider: AnimationFontProvider? = nil) {
        // Steal from MainThreadAnimationLayer.swift
        let layerImageProvider = LayerImageProvider(imageProvider: (imageProvider ?? BundleImageProvider(bundle: .main, searchPath: nil)).cachedImageProvider, assets: animation.assetLibrary?.imageAssets)
        let layerTextProvider = LayerTextProvider(textProvider: textProvider ?? DefaultTextProvider())
        let layerFontProvider = LayerFontProvider(fontProvider: fontProvider ?? DefaultFontProvider())
        
        let layers = animation.layers.initializeCompositionLayers(assetLibrary: animation.assetLibrary, layerImageProvider: layerImageProvider, textProvider: layerTextProvider.textProvider, fontProvider: layerFontProvider.fontProvider, frameRate: CGFloat(animation.framerate))
        super.init()
        bounds = animation.bounds
        
        var imageLayers = [ImageCompositionLayer]()
        var textLayers = [TextCompositionLayer]()
        
        for layer in layers.reversed() {
            layer.bounds = bounds
            animationLayers.append(layer)
            if let imageLayer = layer as? ImageCompositionLayer {
                imageLayers.append(imageLayer)
            }
            if let textLayer = layer as? TextCompositionLayer {
                textLayers.append(textLayer)
            }
            addSublayer(layer)
        }
        
        layerImageProvider.addImageLayers(imageLayers)
        layerImageProvider.reloadImages()
        layerTextProvider.addTextLayers(textLayers)
        layerTextProvider.reloadTexts()
        layerFontProvider.addTextLayers(textLayers)
        layerFontProvider.reloadTexts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Display the layer tree to specify frame time, then call `render(in:)` to draw on CGBitmapContext
    /// - Parameters:
    ///   - frame: The AnimationFrameTime(Seconds * Framerate)
    ///   - forceUpdates: Whether to force update the tree node, true need time but more accurate rendering result
    public func displayWithFrame(frame: CGFloat, forceUpdates: Bool) {
        animationLayers.forEach { $0.displayWithFrame(frame: frame, forceUpdates: forceUpdates) }
    }
}
