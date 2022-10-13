//
//  TabBarInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarInteracting: AnyObject {
    func getAllLocations(completion: @escaping (Bool?) -> Void)
}

class TabBarInteractor {
    private let presenter: TabBarPresenting
    
    init(presenter: TabBarPresenting) {
        self.presenter = presenter
    }
}

extension TabBarInteractor: TabBarInteracting {
    func getAllLocations(completion: @escaping (Bool?) -> Void) {
        Client.getAllLocations { [weak self] error in
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
}
