//
//  AddLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum AddLocationAction {
    case dismiss
    case presentPostLocationViewController(_ location: String,
                                           _ mediaURL: String,
                                           _ coordinates: (Double, Double))
}

protocol AddLocationCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: AddLocationAction)
}

class AddLocationCoordinator {
    weak var viewController: UIViewController?
}

extension AddLocationCoordinator: AddLocationCoordinating {
    func perform(action: AddLocationAction) {
        switch action {
        case .dismiss:
            viewController?.navigationController?.dismiss(animated: true)
        case .presentPostLocationViewController(let location, let mediaURL, let coordinates):
            let scene = PostLocationViewControllerFactory.make(location, mediaURL, coordinates)
            viewController?.navigationController?.pushViewController(scene, animated: true)
        }
    }
}
