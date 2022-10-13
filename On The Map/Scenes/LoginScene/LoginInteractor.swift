//
//  LoginInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import Foundation

protocol LoginInteracting: AnyObject {
    func login(username: String, password: String)
}

class LoginInteractor {
    private let presenter: LoginPresenting
    
    init(presenter: LoginPresenting) {
        self.presenter = presenter
    }
}

extension LoginInteractor: LoginInteracting {
    
    func login(username: String, password: String) {
        presenter.startLoading()
        Client.login(username: username, password: password) { [weak self] success, error in
            self?.presenter.stopLoading()
            if success {
                self?.presenter.presentTabBar()
            } else {
                if let error {
                    self?.presenter.displayError(error.localizedDescription)
                }
            }
        }
    }
}
