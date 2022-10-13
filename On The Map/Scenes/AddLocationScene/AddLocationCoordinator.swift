//
//  AddLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol AddLocationCoordinating: AnyObject {
    var navigationController: UINavigationController? { get set }
    func presentPostLocationViewController(_ location: String,
                                           _ mediaURL: String,
                                           _ coordinates: (Double, Double))
}

class AddLocationCoordinator {
    weak var navigationController: UINavigationController?
}

extension AddLocationCoordinator: AddLocationCoordinating {
    func presentPostLocationViewController(_ location: String,
                                           _ mediaURL: String,
                                           _ coordinates: (Double, Double)) {
        let postLocationViewController = PostLocationViewControllerFactory.make(location,
                                                                                mediaURL, coordinates)
        navigationController?.pushViewController(postLocationViewController, animated: true)
    }
}
