//
//  LoginCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

enum LoginAction {
    case presentTabBar
    case openLink
}

protocol LoginCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: LoginAction)
}

class LoginCoordinator {
    weak var viewController: UIViewController?
}

extension LoginCoordinator: LoginCoordinating {
    func perform(action: LoginAction) {
        switch action {
        case .presentTabBar:
            showTabBarFlow()
        case .openLink:
            linkOpener()
        }
    }
    
    private func linkOpener() {
        let url = URL(string: "https://auth.udacity.com/sign-up")
        UIApplication.shared.open(url!, options: [:])
    }
    
    private func showTabBarFlow() {
        let scene = TabBarControllerFactory.make()
        scene.modalPresentationStyle = .fullScreen
        viewController?.present(scene, animated: true)
    }
}
