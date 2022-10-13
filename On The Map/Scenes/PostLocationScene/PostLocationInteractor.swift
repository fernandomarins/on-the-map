//
//  PostLocationInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol PostLocationInteracting: AnyObject {
    func getUserInfo(completion: @escaping (Bool) -> Void)
    func post(_ location: String,
              _ mediaURL: String,
              _ coordinates: (latitude: Double, longitude: Double))
    func dismiss()
    func dismissAll()
}

class PostLocationInteractor {
    private let presenter: PostLocationPresenting
    
    init(presenter: PostLocationPresenting) {
        self.presenter = presenter
    }
}

extension PostLocationInteractor: PostLocationInteracting {
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        presenter.startLoading()
        Client.getUserInfo { [weak self] success, error in
            self?.presenter.stopLoading()
            if success {
                completion(true)
                return
            }
            
            if let error {
                self?.presenter.displayError(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func post(_ location: String,
              _ mediaURL: String,
              _ coordinates: (latitude: Double, longitude: Double)) {
        presenter.startLoading()
        let postLocation = PostLocation(uniqueKey: Client.Auth.uniqueKey,
                                        firstName: Client.Auth.firstName,
                                        lastName: Client.Auth.lastName,
                                        mapString: location,
                                        mediaURL: mediaURL,
                                        latitude: coordinates.latitude,
                                        longitude: coordinates.longitude)
        Client.post(student: postLocation) { [weak self] success, error in
            self?.presenter.stopLoading()
            if success {
                NotificationCenter.default.post(name: NSNotification.Name("update"),
                                                object: nil)
                self?.presenter.dismiss()
            } else {
                if let error {
                    self?.presenter.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func dismiss() {
        presenter.dismiss()
    }
    
    func dismissAll() {
        presenter.dismissAll()
    }
}
