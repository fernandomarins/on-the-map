//
//  TabBarInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarInteracting: AnyObject {
    func getAllLocations(completion: @escaping (Bool?) -> Void)
    func openLink(_ urlString: String)
    func logout()
    func presentAddLocation()
}

class TabBarInteractor {
    private let service: APIServiceProtocol
    private let presenter: TabBarPresenting
    
    init(presenter: TabBarPresenting, service: APIServiceProtocol = APIService()) {
        self.presenter = presenter
        self.service = service
    }
}

extension TabBarInteractor: TabBarInteracting {
    func getAllLocations(completion: @escaping (Bool?) -> Void) {
        presenter.startLoading()
        service.getAllLocations { [weak self] error in
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
    
    func openLink(_ urlString: String) {
        presenter.openLink(urlString)
    }
    
    func logout() {
        service.logout { [weak self] success, error in
            if success {
                self?.presenter.logout()
            } else {
                if let error {
                    self?.presenter.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func presentAddLocation() {
        presenter.presentAddLocation()
    }
}
