//
//  AddLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol AddLocationCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func presentPostLocationViewController(_ location: String,
                                           _ mediaURL: String,
                                           _ coordinates: (Double, Double))
    func dismiss()
}

class AddLocationCoordinator {
    weak var viewController: UIViewController?
}

extension AddLocationCoordinator: AddLocationCoordinating {
    func presentPostLocationViewController(_ location: String,
                                           _ mediaURL: String,
                                           _ coordinates: (Double, Double)) {
        let postLocationViewController = PostLocationViewControllerFactory.make(location,
                                                                                mediaURL, coordinates)
        let navigationController = UINavigationController(rootViewController: postLocationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
