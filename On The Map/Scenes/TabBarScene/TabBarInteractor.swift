//
//  TabBarInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarInteracting: AnyObject {
    func getAllLocations(completion: @escaping (Bool) -> Void)
    func openLink(_ urlString: String)
    func logout()
    func presentAddLocation()
}

final class TabBarInteractor {
    private let service: APIServiceProtocol
    private let presenter: TabBarPresenting
    
    init(presenter: TabBarPresenting, service: APIServiceProtocol = APIService()) {
        self.presenter = presenter
        self.service = service
    }
}

extension TabBarInteractor: TabBarInteracting {
    func getAllLocations(completion: @escaping (Bool) -> Void) {
        presenter.startLoading()
        service.getAllLocations { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                self?.presenter.displayError(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func openLink(_ urlString: String) {
        presenter.openLink(action: .openLink(urlString))
    }
    
    func logout() {
        presenter.startLoading()
        service.logout { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success:
                self?.presenter.logout(action: .logout)
            case .failure(let error):
                self?.presenter.displayError(error.localizedDescription)
            }
        }
    }
    
    func presentAddLocation() {
        presenter.presentAddLocation(action: .presentAddLocationFlow)
    }
}
