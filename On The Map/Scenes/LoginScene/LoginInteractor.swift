//
//  LoginInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import Foundation

protocol LoginInteracting: AnyObject {
    func login(username: String, password: String)
    func openLink()
}

class LoginInteractor {
    private let service: APIServiceProtocol
    private let presenter: LoginPresenting
    
    init(presenter: LoginPresenting, service: APIServiceProtocol = APIService()) {
        self.presenter = presenter
        self.service = service
    }
}

extension LoginInteractor: LoginInteracting {
    func login(username: String, password: String) {
        presenter.startLoading()
        service.login(username: username, password: password) { [weak self] success, error in
            self?.presenter.stopLoading()
            if success {
                self?.presenter.presentTabBar(action: .presentTabBar)
            } else {
                if let error {
                    self?.presenter.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func openLink() {
        presenter.openLink(action: .openLink)
    }
}
