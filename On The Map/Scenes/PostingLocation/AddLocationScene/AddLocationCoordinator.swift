//
//  AddLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum AddLocationAction {
    case dismiss
    case presentPost(location: Location)
}

protocol AddLocationCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: AddLocationAction)
}

final class AddLocationCoordinator {
    weak var viewController: UIViewController?
}

extension AddLocationCoordinator: AddLocationCoordinating {
    func perform(action: AddLocationAction) {
        switch action {
        case .dismiss:
            viewController?.navigationController?.dismiss(animated: true)
        case .presentPost(let location):
            let scene = PostLocationViewControllerFactory.make(location)
            viewController?.navigationController?.pushViewController(scene, animated: true)
        }
    }
}
