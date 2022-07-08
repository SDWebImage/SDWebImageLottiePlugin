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
        let animationView = AnimationView()
        let lottieURL = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/happy2016/data.json")
        animationView.sd_setImage(with: lottieURL, completed: { (image, error, cacheType, url) in
            XCTAssertNil(error)
            let lottieImage = try! XCTUnwrap(image)
            XCTAssertTrue(lottieImage.isKind(of: LottieImage.self))
            let animation = try! XCTUnwrap((lottieImage as! LottieImage).animation)
            XCTAssertEqual(animation.size, CGSize(width: 1920, height: 1080))
            exception.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAnimatedControlLoad() {
        let exception = self.expectation(description: "AnimatedControl load lottie URL")
        let animationView = AnimatedSwitch()
        let lottieURL = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/adrock/data.json")
        animationView.sd_setImage(with: lottieURL, completed: { (image, error, cacheType, url) in
            XCTAssertNil(error)
            let lottieImage = try! XCTUnwrap(image)
            XCTAssertTrue(lottieImage.isKind(of: LottieImage.self))
            let animation = try! XCTUnwrap((lottieImage as! LottieImage).animation)
            XCTAssertEqual(animation.size, CGSize(width: 690, height: 913))
            exception.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLottieImageWithBundle() throws {
        let bundle = Bundle(for: type(of: self))
        let fileURL = bundle.url(forResource: "Assets", withExtension: "json")!
        let lottieData = try Data(contentsOf: fileURL)
        let animation = try JSONDecoder().decode(Animation.self, from: lottieData)
        let animationView = AnimationView(animation: animation, imageProvider: BundleImageProvider(bundle: bundle, searchPath: nil))
        let renderer = SDGraphicsImageRenderer(size: animation.size)
        let viewImage = renderer.image { context in
            animationView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: animation.size), afterScreenUpdates: true)
        }
        // Pick the color to check
        let color1 = try XCTUnwrap(viewImage.sd_color(at: CGPoint(x: 150, y: 150)))
        XCTAssertEqual(color1.toHexString(), "#00d1c1");
        
        let lottieImage = LottieImage(animation: animation)
        lottieImage.imageProvider = BundleImageProvider(bundle: bundle, searchPath: nil)
        let posterFrame = try XCTUnwrap(lottieImage.animatedImageFrame(at: 0))
        // Pick the color to check
        let color2 = try XCTUnwrap(posterFrame.sd_color(at: CGPoint(x: 150, y: 150)))
        XCTAssertEqual(color2.toHexString(), "#00d1c1");
    }

    
    func testLottieImageExtractFrame() {
        let exception = self.expectation(description: "LottieImage extract frame")
        let lottieUrl = URL(string: "https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/gatin/data.json")!
        let task = URLSession.shared.dataTask(with: lottieUrl) { data, _, _ in
            if let data = data, let animation = try? JSONDecoder().decode(Animation.self, from: data) {
                let lottieImage = LottieImage(animation: animation)
                let frameCount = lottieImage.animatedImageFrameCount
                XCTAssertEqual(frameCount, 80)
                let posterFrame = lottieImage.animatedImageFrame(at: 0)
                let lastFrame = lottieImage.animatedImageFrame(at: frameCount - 1)
                XCTAssertNotNil(posterFrame)
                XCTAssertNotNil(lastFrame)
                XCTAssertNotEqual(posterFrame, lastFrame)
                exception.fulfill()
            } else {
                XCTFail()
            }
        }
        task.resume()
        self.waitForExpectations(timeout: 5, handler: nil)
    }
}
