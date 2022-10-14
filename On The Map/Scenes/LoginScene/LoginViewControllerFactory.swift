//
//  LoginViewControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

class LoginViewControllerFactory {
    
    static func make() -> UIViewController {
        let coordinator: LoginCoordinating = LoginCoordinator()
        let presenter: LoginPresenting = LoginPresenter(coordinator: coordinator)
        let interactor: LoginInteracting = LoginInteractor(presenter: presenter)
        
        let viewController = LoginViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
