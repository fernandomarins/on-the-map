//
//  AddLocationViewControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum AddLocationViewControllerFactory {
    static func make() -> UIViewController {
        let coordinator: AddLocationCoordinating = AddLocationCoordinator()
        let presenter: AddLocationPresenting = AddLocationPresenter(coordinator: coordinator)
        let interactor: AddLocationInteracting = AddLocationInteractor(presenter: presenter)
        
        let viewController = AddLocationViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
