//
//  PostLocationViewControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum PostLocationViewControllerFactory {
    static func make(_ location: Location) -> UIViewController {
        let coordinator: PostLocationCoordinating = PostLocationCoordinator()
        let presenter: PostLocationPresenting = PostLocationPresenter(coordinator: coordinator)
        let interactor: PostLocationInteracting = PostLocationInteractor(presenter: presenter)
        
        let viewController = PostLocationViewController(interactor: interactor,
                                                        location: location)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
