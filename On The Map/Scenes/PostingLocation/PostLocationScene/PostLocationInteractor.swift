//
//  PostLocationInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol PostLocationInteracting: AnyObject {
    func getUserInfo(completion: @escaping (Bool) -> Void)
    func post(_ location: Location)
    func dismiss()
    func dismissToTabBar()
}

class PostLocationInteractor {
    private let service: APIServiceProtocol
    private let presenter: PostLocationPresenting
    
    init(presenter: PostLocationPresenting, service: APIServiceProtocol = APIService()) {
        self.presenter = presenter
        self.service = service
    }
}

extension PostLocationInteractor: PostLocationInteracting {
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        presenter.startLoading()
        service.getUserInfo { [weak self] result in
            self?.presenter.stopLoading()
            
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                self?.presenter.displayError(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func post(_ location: Location) {
        presenter.startLoading()
        let postLocation = PostLocation(uniqueKey: APIService.Auth.uniqueKey,
                                        firstName: APIService.Auth.firstName,
                                        lastName: APIService.Auth.lastName,
                                        mapString: location.location,
                                        mediaURL: location.mediaURL,
                                        latitude: location.coordinates.latitude,
                                        longitude: location.coordinates.longitude)
        service.post(student: postLocation) { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success(_):
                self?.sendNotification()
                self?.presenter.dismiss(action: .dismissTabBar)
            case .failure(let error):
                self?.presenter.displayError(error.localizedDescription)
            }
        }
    }
    
    func dismiss() {
        presenter.dismiss(action: .dismiss)
    }
    
    func dismissToTabBar() {
        presenter.dismissToTabBar(action: .dismissTabBar)
    }
    
    private func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("update"),
                                        object: nil)
    }
}
