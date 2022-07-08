/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import Cocoa
import Lottie

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        LottieConfiguration.shared.renderingEngine = .coreAnimation
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

