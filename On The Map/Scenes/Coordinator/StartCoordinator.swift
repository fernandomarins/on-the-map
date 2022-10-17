//
//  StartCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 14/10/22.
//

import UIKit

protocol StartCoordinating {
    func start(with scene: UIWindowScene) -> UIWindow
}

final class StartCoordinator: StartCoordinating {
    func start(with scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        let viewController = LoginViewControllerFactory.make()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return window
    }
}
