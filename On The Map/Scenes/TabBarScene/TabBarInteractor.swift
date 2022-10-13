//
//  TabBarInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarInteracting: AnyObject {
    func getAllLocations(completion: @escaping (Bool?) -> Void)
    func presentAddLocation()
}

class TabBarInteractor {
    private let presenter: TabBarPresenting
    
    init(presenter: TabBarPresenting) {
        self.presenter = presenter
    }
}

extension TabBarInteractor: TabBarInteracting {
    func getAllLocations(completion: @escaping (Bool?) -> Void) {
        presenter.startLoading()
        Client.getAllLocations { [weak self] error in
            self?.presenter.stopLoading()
            if error == nil {
                completion(true)
            } else {
                if let error {
                    self?.presenter.displayError(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func presentAddLocation() {
        presenter.presentAddLocation()
    }
}
