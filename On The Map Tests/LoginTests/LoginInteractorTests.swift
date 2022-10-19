//
//  LoginInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 17/10/22.
//

import XCTest
@testable import On_The_Map

private final class LoginPresenterSpy: LoginPresenting {
    
    enum Message {
        case presentTabBar
        case displayError
        case openLink
        case startLoading
        case stopLoading
    }
    
    private(set) var messagsSent: [Message] = []
    
    private(set) var action: LoginAction?
    private(set) var error: String?
    
    var viewController: LoginViewDisplyaing?
    
    func presentTabBar(action: LoginAction) {
        messagsSent.append(.presentTabBar)
        self.action = action
    }
    
    func displayError(_ error: String) {
        messagsSent.append(.displayError)
        self.error = error
    }
    
    func openLink(action: LoginAction) {
        messagsSent.append(.openLink)
        self.action = action
    }
    
    func startLoading() {
        messagsSent.append(.startLoading)
    }
    
    func stopLoading() {
        messagsSent.append(.stopLoading)
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
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading,
                                                  .stopLoading,
                                                  .presentTabBar])
    }
    
    func testLoginShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        
        sut.login(username: "", password: "")
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testOpenLinkShouldPass() {
        serviceMock.result = .success(true)
        
        sut.openLink()
        
        XCTAssertEqual(presenterSpy.messagsSent, [.openLink])
        XCTAssertEqual(presenterSpy.action, .openLink)
    }
}
