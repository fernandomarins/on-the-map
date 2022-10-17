//
//  LoginInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 17/10/22.
//

import Foundation
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
