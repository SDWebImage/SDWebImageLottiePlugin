import XCTest
import Lottie
import SDWebImage
@testable import SDWebImageLottiePlugin

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format: "#%06x", rgb)
    }
}

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testAnimatedImageViewLoad() {
        let exception = self.expectation(description: "AnimationView load lottie URL")
        let animationView = LOTAnimationView()
        let lottieURL = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/happy2016/data.json")
        animationView.sd_setImage(with: lottieURL) { (image, error, cacheType, url) in
            XCTAssertNil(error)
            let lottieImage = try! XCTUnwrap(image)
            XCTAssertTrue(lottieImage.isKind(of: LOTAnimatedImage.self))
            let animation = try! XCTUnwrap((lottieImage as! LOTAnimatedImage).composition)
            XCTAssertEqual(animation.compBounds.size, CGSize(width: 1920, height: 1080))
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAnimatedControlLoad() {
        let exception = self.expectation(description: "AnimatedControl load lottie URL")
        let animationView = LOTAnimatedSwitch()
        let lottieURL = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/adrock/data.json")
        animationView.sd_setImage(with: lottieURL) { (image, error, cacheType, url) in
            XCTAssertNil(error)
            let lottieImage = try! XCTUnwrap(image)
            XCTAssertTrue(lottieImage.isKind(of: LOTAnimatedImage.self))
            let animation = try! XCTUnwrap((lottieImage as! LOTAnimatedImage).composition)
            XCTAssertEqual(animation.compBounds.size, CGSize(width: 690, height: 913))
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLottieImageWithBundle() throws {
        let bundle = Bundle(for: type(of: self))
        let fileURL = bundle.url(forResource: "Assets", withExtension: "json")!
        let lottieData = try Data(contentsOf: fileURL)
        let context = [SDWebImageContextOption.lottieBundle : bundle]
        let lottieImage = LOTAnimatedImage(data: lottieData, scale: 1, options: [.webImageContext: context])!
        let posterFrame = try XCTUnwrap(lottieImage.animatedImageFrame(at: 0))
        // Pick the color to check
        let color = try XCTUnwrap(posterFrame.sd_color(at: CGPoint(x: 150, y: 150)))
        XCTAssertEqual(color.toHexString(), "#00d1c1");
    }
    
}
