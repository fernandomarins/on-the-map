//
//  LoginPresenterTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 14/10/22.
//

import XCTest
@testable import On_The_Map

private final class LoginViewControllerSpy: LoginViewDisplyaing {
    var activityIndicator = LoadingView()
    private(set) var messagesSent: [Messages] = []
    private(set) var error: String?
    
    enum Messages {
        case presentTabBar
        case openLink
        case displayError
        case startLoadingView
        case stopLoadingView
    }
    
    func login() {
        messagesSent.append(.presentTabBar)
    }
    
    func openLink() {
        messagesSent.append(.openLink)
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

final private class LoginCoordinatorSpy: LoginCoordinating {
    var viewController: UIViewController?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: LoginAction?
    
    enum Messages {
        case perform
    }
    
    func perform(action: LoginAction) {
        messagesSent.append(.perform)
        self.action = action
    }
}

final class LoginPresenterTests: XCTestCase {
    private let viewControllerSpy = LoginViewControllerSpy()
    private let coordinatorSpy = LoginCoordinatorSpy()
    
    private var sut: LoginPresenter {
        let presenter = LoginPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }

    func testPerformPresentTabBar() {
        sut.presentTabBar(action: .presentTabBar)
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .presentTabBar)
    }
    
    func testOpenUrl() {
        sut.openLink(action: .openLink)
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .openLink)
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
}
