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
        viewController?.present(postLocationViewController, animated: true)
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
