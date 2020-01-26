import XCTest
import CoreData
@testable import PersistanceManager

@available(iOS 10.0, *)
final class PersistanceManagerTests: XCTestCase {

    func testPackage() {
        XCTAssertEqual(true, true)
    }

    static var allTests = [
        ("testPackage", testPackage),
    ]
}
