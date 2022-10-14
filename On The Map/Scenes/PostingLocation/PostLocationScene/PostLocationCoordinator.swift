//
//  PostLocationCoordinator.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum PostLocationAction {
    case dismiss
    case dismissTabBar
}

protocol PostLocationCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: PostLocationAction)
}

class PostLocationCoordinator {
    weak var viewController: UIViewController?
}

extension PostLocationCoordinator: PostLocationCoordinating {
    func perform(action: PostLocationAction) {
        switch action {
        case .dismiss:
            dismiss()
        case .dismissTabBar:
            dismissToTabBar()
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
    
    func dismissToTabBar() {        
        viewController?.navigationController?.dismiss(animated: true)
    }
}
