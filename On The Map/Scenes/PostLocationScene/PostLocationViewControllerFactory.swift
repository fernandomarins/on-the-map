//
//  PostLocationViewControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

class PostLocationViewControllerFactory {
    
    static func make(_ location: String,
                     _ mediaURL: String,
                     _ coordinates: (latitude: Double, longitude: Double)) -> UIViewController {
        let coordinator: PostLocationCoordinating = PostLocationCoordinator()
        let presenter: PostLocationPresenting = PostLocationPresenter(coordinator: coordinator)
        let interactor: PostLocationInteracting = PostLocationInteractor(presenter: presenter)
        
        let viewController = PostLocationViewController(interactor: interactor,
                                                        coordinates: coordinates,
                                                        mediaURL: mediaURL,
                                                        location: location)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
