//
//  iOS_BrowserUITests.swift
//  iOS_BrowserUITests
//
//  Created by Yen Shou on 3/19/21.
//

import XCTest

class iOS_BrowserUITests: XCTestCase {

    var app: XCUIApplication = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["-NSDoubleLocalizedStrings", "YES"]
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.terminate()
    }

    func testUrlExists() throws {
        XCTAssert(app.textFields["url"].exists)
    }
    
    func testTabsExists() throws {
        XCTAssert(app.buttons["Tabs"].exists)
    }
    
    func testBackExists() throws {
        XCTAssert(app.buttons["Back"].exists)
    }
    
    func testForwardExists() throws {
        XCTAssert(app.buttons["Forward"].exists)
    }
    
    func testAddExists() throws {
        XCTAssert(app.buttons["addBookmark"].exists)
    }
    
    func testBookmarkExists() throws {
        XCTAssert(app.buttons["Bookmarks"].exists)
    }
    
    func testReloadExists() throws {
        XCTAssert(app.buttons["Reload"].exists)
    }
    
    func testaddTabExists() throws {
        app.buttons["Tabs"].tap()
        XCTAssert(app.buttons["addTab"].exists)
    }
    
    func testTypeUrl() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://m.youtube.com/")
        app.typeText("\r")
        sleep(3)
        XCTAssertEqual(textField.value as? String ?? "", "https://m.youtube.com/")
    }
    
    func testBackTappable() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.google.com/")
        app.typeText("\r")
        XCTAssertTrue(app.buttons["Back"].isHittable)
    }
    
    func testBackTap() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.snapchat.com")
        app.typeText("\r")
        sleep(1)
        app.buttons["Back"].tap()
        XCTAssertEqual(textField.value as? String ?? "", "https://www.google.com/")
    }
    
    func testForwardTappable() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.apple.com/")
        app.typeText("\r")
        app.buttons["Back"].tap()
        XCTAssertTrue(app.buttons["Forward"].isHittable)
    }
    
    func testForwardTap() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.google.com/")
        app.typeText("\r")
        sleep(1)
        app.buttons["Back"].tap()
        sleep(1)
        app.buttons["Forward"].tap()
        XCTAssertEqual(textField.value as? String ?? "", "https://www.google.com/")
    }
    
    func testAddBookmark() throws {
        // UI tests must launch the application that they test.
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.google.com")
        app.typeText("\r")
        app.buttons["addBookmark"].tap()
        app.buttons["Bookmarks"].tap()
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssert(cell.exists)
    }
    
    func testAddTab() throws {
        // UI tests must launch the application that they test.
        app.buttons["Tabs"].tap()
        app.buttons["addTab"].tap()
        let textField = app.textFields["url"]
        textField.doubleTap()
        textField.typeText("https://www.amazon.com/")
        app.typeText("\r")
        sleep(3)
        XCTAssertEqual(app.textFields["url"].value as? String ?? "", "https://www.amazon.com/")
    }
    
    func testChangeTab() throws {
        // UI tests must launch the application that they test.
        app.buttons["Tabs"].tap()
        app.tables.cells.element(boundBy: 1).tap()
        app.buttons["Tabs"].tap()
        app.tables.cells.element(boundBy: 0).tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
