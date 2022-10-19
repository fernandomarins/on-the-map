//
//  TabBarCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum TabBarAction: Equatable {
    case presentAddLocationFlow
    case openLink(_ urlString: String)
    case logout
}

protocol TabBarCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: TabBarAction)
}

final class TabBarCoordinator {
    weak var viewController: UIViewController?
}

extension TabBarCoordinator: TabBarCoordinating {
    
    func perform(action: TabBarAction) {
        switch action {
        case .presentAddLocationFlow:
            presentAddViewController()
        case .openLink(let urlString):
            openLink(urlString)
        case .logout:
            logout()
        }
    }
    
    private func presentAddViewController() {
        let addLocationViewController = AddLocationViewControllerFactory.make()
        let navigationController = UINavigationController(rootViewController: addLocationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
    
    private func openLink(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func logout() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
