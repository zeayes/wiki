import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {

    func testAdd() {
        XCTAssertEqual(Calculator().add(1, 1), 2)
    }

    func testSub() {
        XCTAssertEqual(Calculator().sub(2, 1), 1)
    }

    func testMul() {
        XCTAssertEqual(Calculator().mul(1, 1), 1)
    }

    func testDiv() {
        XCTAssertEqual(Calculator().div(2, 1), 2)
    }


    static var allTests : [(String, (CalculatorTests) -> () throws -> Void)] {
        return [
            ("testAdd", testAdd),
            ("testSub", testSub),
            ("testMul", testMul),
            ("testDiv", testDiv),
        ]
    }
}
