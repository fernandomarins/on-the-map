//
//  LoginPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import Foundation

protocol LoginPresenting: AnyObject {
    var viewController: LoginViewDisplyaing? { get set }
    func presentTabBar(action: LoginAction)
    func displayError(_ error: String)
    func openLink(action: LoginAction)
    func startLoading()
    func stopLoading()
}

final class LoginPresenter {
    weak var viewController: LoginViewDisplyaing?
    private let coordinator: LoginCoordinating
    
    init(coordinator: LoginCoordinating) {
        self.coordinator = coordinator
    }
}

extension LoginPresenter: LoginPresenting {

    func presentTabBar(action: LoginAction) {
        coordinator.perform(action: action)
    }
    
    func displayError(_ error: String) {
        viewController?.displayError(error)
    }
    
    func openLink(action: LoginAction) {
        coordinator.perform(action: action)
    }
    
    func startLoading() {
        viewController?.startLoadingView()
    }
    
    func stopLoading() {
        viewController?.stopLoadingView()
    }
}
