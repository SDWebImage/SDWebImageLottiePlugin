import XCTest
import Lottie
import SDWebImage
@testable import SDWebImageLottiePlugin

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
        animationView.sd_setImage(with: lottieURL) { (image, error, cacheType, url) in
            XCTAssertNil(error)
            let lottieImage = try! XCTUnwrap(image)
            XCTAssertTrue(lottieImage.isKind(of: LottieImage.self))
            let animation = try! XCTUnwrap((lottieImage as! LottieImage).animation)
            XCTAssertEqual(animation.size, CGSize(width: 1920, height: 1080))
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
}
