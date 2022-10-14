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
    func openLink(_ urlString: String)
    func logout()
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
    
    func openLink(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    func logout() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
