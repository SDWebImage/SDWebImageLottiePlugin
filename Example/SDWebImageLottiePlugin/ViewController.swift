/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import UIKit
import Lottie
import SDWebImageLottiePlugin
import SDWebImage

class ViewController: UIViewController {
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.contentMode = .scaleAspectFit
        animationView.frame = self.view.bounds
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(animationView)
        
        let lottieUrl = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/gatin/data.json")
        animationView.sd_setImage(with: lottieUrl, completed: { _,_,_,_ in
            self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .repeat(5)) { finished in
                if finished {
                    print("Animation Complete")
                } else {
                    print("Animation cancelled")
                }
            }
        })
    }
    
}

