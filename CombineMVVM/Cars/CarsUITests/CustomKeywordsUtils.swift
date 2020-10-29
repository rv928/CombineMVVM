//
//  CustomKeywordsUtils.swift


import Foundation
import XCTest

enum SwipeSide {
    case left
    case right
    case up
    case down
}

class CustomKeywordsUtils {
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                    object: element)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func waitAndTap(element: XCUIElement) {
        waitAndTap(element: element, timeout: 10)
    }
    
    func waitAndTap(element: XCUIElement, message: String) {
        waitAndTap(element: element, timeout: 10)
    }
    
    func waitAndTap(element: XCUIElement, timeout: Double, message: String = "") {
        let elementExist = element.waitForExistence(timeout: timeout)
        XCTAssert(elementExist, message)
        element.tap()
    }
    
    func waitUntilClickable(element: XCUIElement, timeout: Int) {
        var count: Int = 0
        element.waitForExistence(timeout: TimeInterval(timeout))
        while (!element.isHittable) {
            count += 1
            sleep(1)
            if count > timeout {
                break
            }
        }
    }
    
    func waitElementToAppear(element: XCUIElement, timeout: TimeInterval=5)->XCUIElement {
        let _ = element.waitForExistence(timeout: timeout)
        return element
    }
    
    
    func swipeToFindElement(app: XCUIApplication, element: XCUIElement, count: Int){
        var loop: Int = 0
        let elementExist = element.waitForExistence(timeout: 5)
        XCTAssert(elementExist)
        while (!element.isHittable && loop < count) {
            app.swipeUp()
            loop += 1
        }
    }
    
    func swipeToExpectedCellByText(collectionView: XCUIElement, expectedText: String, loopCount: Int, swipeSide: SwipeSide) -> XCUIElement? {
        //method for cell can't clickable. collectionview corousel
        let elementExist = collectionView.waitForExistence(timeout: 5)
        XCTAssert(elementExist)
        var count = max(loopCount, 0)
        
        while count != 0 {
            for index in 0..<collectionView.cells.countForHittables {
                let cell = collectionView.cells.element(boundBy: index)
                if cell.staticTexts[expectedText].exists, cell.staticTexts[expectedText].isHittable {
                    return cell
                }
            }
            
            switch(swipeSide) {
            case .left:
                collectionView.swipeLeft()
            case .right:
                collectionView.swipeRight()
            case .up:
                collectionView.swipeUp()
            case .down:
                collectionView.swipeDown()
            }
            count -= 1
        }
        
        return nil
    }
    
    
    func deleteOnlyApp() {
        let appName = "Cars"
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        XCUIApplication().terminate()
        
        // Force delete the app from the springboard
        let icon = springboard.icons[appName]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.5)
            
            // Tap the little "X" button at approximately where it is. The X is not exposed directly
            if #available(iOS 13, *) {
                Thread.sleep(forTimeInterval: 1)
                springboard/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Home screen icons\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Delete App"].tap()
                Thread.sleep(forTimeInterval: 1)
                springboard.alerts["Delete “Cars”?"].scrollViews.otherElements.buttons["Delete"].tap()
            } else {
                springboard.coordinate(withNormalizedOffset: CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)).tap()
                
                let _ = springboard.alerts.buttons["Delete"].waitForExistence(timeout: 5)
                springboard.alerts.buttons["Delete"].tap()
                Thread.sleep(forTimeInterval: 1)
            }
            Thread.sleep(forTimeInterval: 1)
        }
    }
}

extension XCUIElementQuery {
    var countForHittables: Int {
        return Int(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}
