//
//  TabBarCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol TabBarCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func presentAddViewController()
}

class TabBarCoordinator {
    weak var viewController: UIViewController?
}

extension TabBarCoordinator: TabBarCoordinating {
    func presentAddViewController() {
        let addLocationViewController = AddLocationViewControllerFactory.make()
        let navigationController = UINavigationController(rootViewController: addLocationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
}
