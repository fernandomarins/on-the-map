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
    
    enum Messages {
        case login
        case openURL
        case displayError
        case startLoadingView
        case stopLoadingView
    }
    
    private(set) var messagesSent: [Messages] = []
    private(set) var error: String?
    
    func login() {
        messagesSent.append(.login)
    }
    
    func openURL() {
        messagesSent.append(.openURL)
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

final class LoginCoordinatorSpy: LoginCoordinating {
    var viewController: UIViewController?
    
    enum Messages {
        case perform
    }
    
    private(set) var messagesSent: [Messages] = []
    private(set) var action: LoginAction?
    
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
        
        XCTAssertEqual(viewControllerSpy.messagesSent, [.login])
    }
    
    func testOpenUrl() {
        sut.presentTabBar(action: .openLink)
        
        XCTAssertEqual(viewControllerSpy.messagesSent, [.openURL])
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
