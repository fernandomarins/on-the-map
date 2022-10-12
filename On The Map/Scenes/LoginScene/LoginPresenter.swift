//
//  LoginPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import Foundation

protocol LoginPresenting: AnyObject {
    var viewController: LoginViewDisplyaing? { get set }
    func presentTabBar()
    func displayError(_ error: Errors)
    func startLoading()
    func stopLoading()
}

class LoginPresenter {
    weak var viewController: LoginViewDisplyaing?
    private let coordinator: LoginCoordinating
    
    init(coordinator: LoginCoordinating) {
        self.coordinator = coordinator
    }
}

extension LoginPresenter: LoginPresenting {

    func presentTabBar() {
        coordinator.presentTabBarController()
    }
    
    func displayError(_ error: Errors) {
        
    }
    
    func startLoading() {
        viewController?.startLoading()
    }
    
    func stopLoading() {
        viewController?.stopLoading()
    }
}
