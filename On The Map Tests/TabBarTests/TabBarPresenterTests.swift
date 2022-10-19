//
//  TabBarPresenterTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

private final class TabBarViewControllerSpy: TabBarDisplaying {
    var activityIndicator = LoadingView()
    private(set) var messagesSent: [Messages] = []
    private(set) var error: String?
    
    enum Messages {
        case startLoadingView
        case stopLoadingView
        case displayError
    }
    
    func displayError(_ error: String) {
        messagesSent.append(.displayError)
        self.error = error
    }
    
    func startLoadingView() {
        messagesSent.append(.startLoadingView)
    }
    
    func stopLoadingView() {
        messagesSent.append(.stopLoadingView)
    }
}

final class TabBarCoordinatorSpy: TabBarCoordinating {
    var viewController: UIViewController?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: TabBarAction?
    
    enum Messages {
        case perform
    }
    
    func perform(action: TabBarAction) {
        messagesSent.append(.perform)
        self.action = action
    }
}

final class TabBarPresenterTests: XCTestCase {
    private let viewControllerSpy = TabBarViewControllerSpy()
    private let coordinatorSpy = TabBarCoordinatorSpy()
    
    private var sut: TabBarPresenter {
        let presenter = TabBarPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }
    
    func testPerformPresentAddLocation() {
        sut.presentAddLocation(action: .presentAddLocationFlow)
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .presentAddLocationFlow)
    }
    
    func testDisplayError() {
        let expectedError = "Error"
        sut.displayError("Error")
        
        XCTAssertEqual(viewControllerSpy.messagesSent, [.displayError])
        XCTAssertEqual(viewControllerSpy.error, expectedError)
    }
    
    func testStartLoadingView() {
        sut.startLoading()
        
        XCTAssertEqual(viewControllerSpy.messagesSent, [.startLoadingView])
    }
    
    func testStopLoadingView() {
        sut.stopLoading()
        
        XCTAssertEqual(viewControllerSpy.messagesSent, [.stopLoadingView])
    }
    
    func testOpenUrl() {
        sut.openLink(action: .openLink("url_string"))
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .openLink("url_string"))
    }
    
    func testLogout() {
        sut.logout(action: .logout)
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .logout)
    }
}
