//
//  PostLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol PostLocationCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func dismiss()
}

class PostLocationCoordinator {
    weak var viewController: UIViewController?
}

extension PostLocationCoordinator: PostLocationCoordinating {
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
