//
//  ViewController.swift
//  SDWebImageLottiePlugin_Example macOS
//
//  Created by 李卓立 on 2020/2/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import Lottie
import SDWebImageLottiePlugin

class ViewController: NSViewController {
    
    let animationView = LOTAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.contentMode = .scaleAspectFit
        animationView.frame = self.view.bounds
        animationView.autoresizingMask = [.width, .height]
        view.addSubview(animationView)
        
        let lottieUrl = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/adrock/data.json")
        animationView.sd_setImage(with: lottieUrl) { (image, error, cacheType, url) in
            self.animationView.play(fromProgress: 0,
                               toProgress: 1,
                               withCompletion: { (finished) in
                                if finished {
                                  print("Animation Complete")
                                } else {
                                  print("Animation cancelled")
                                }
            })
        }
    }

}

