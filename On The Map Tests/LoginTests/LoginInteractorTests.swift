//
//  LoginInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 17/10/22.
//

import XCTest
@testable import On_The_Map

private final class LoginPresenterSpy: LoginPresenting {
    private(set) var messagesSent: [Messages] = []
    private(set) var action: LoginAction?
    private(set) var error: String?
    
    enum Messages {
        case presentTabBar
        case displayError
        case openLink
        case startLoading
        case stopLoading
    }
    
    var viewController: LoginViewDisplyaing?
    
    func presentTabBar(action: LoginAction) {
        messagesSent.append(.presentTabBar)
        self.action = action
    }
    
    func displayError(_ error: String) {
        messagesSent.append(.displayError)
        self.error = error
    }
    
    func openLink(action: LoginAction) {
        messagesSent.append(.openLink)
        self.action = action
    }
    
    func startLoading() {
        messagesSent.append(.startLoading)
    }
    
    func stopLoading() {
        messagesSent.append(.stopLoading)
    }
}

final class LoginInteractorTests: XCTestCase {
    private let presenterSpy = LoginPresenterSpy()
    private var serviceMock = NetworkStub(session: URLSession.shared)
    
    private var sut: LoginInteractor {
        let interactor = LoginInteractor(presenter: presenterSpy,
                                         service: serviceMock)
        return interactor
    }
    
    func testLoginShouldPass() {
        serviceMock.result = .success(true)
        sut.login(username: "", password: "")
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                  .presentTabBar])
    }
    
    func testLoginShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        sut.login(username: "", password: "")
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testOpenLinkShouldPass() {
        serviceMock.result = .success(true)
        sut.openLink()
        
        XCTAssertEqual(presenterSpy.messagesSent, [.openLink])
        XCTAssertEqual(presenterSpy.action, .openLink)
    }
}
