//
//  LoginCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

protocol LoginCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func presentTabBarController()
}

class LoginCoordinator {
    weak var viewController: UIViewController?
}

extension LoginCoordinator: LoginCoordinating {
    func presentTabBarController() {
        let tabBarController = TabBarControllerFactory.make()
        tabBarController.modalPresentationStyle = .fullScreen
        viewController?.present(tabBarController, animated: true)
    }
}
