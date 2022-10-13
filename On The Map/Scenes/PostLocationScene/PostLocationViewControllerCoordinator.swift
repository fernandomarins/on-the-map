//
//  PostLocationViewControllerCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol PostLocationViewControllerCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func dismiss()
}

class PostLocationViewControllerCoordinator {
    weak var viewController: UIViewController?
}

extension PostLocationViewControllerCoordinator: PostLocationViewControllerCoordinating {
    func dismiss() {
        
    }
}
