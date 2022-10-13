//
//  AddLocationPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol AddLocationPresenting: AnyObject {
    var viewController: AddLocationDisplaying? { get set }
    func presentPostLocationViewController(_ location: String, _ mediaURL: String, _ coordinates: (Double, Double))
    func displayError(_ error: String)
    func startLoading()
    func stopLoading()
}

class AddLocationPresenter {
    weak var viewController: AddLocationDisplaying?
    private let coordinator: AddLocationCoordinating
    
    init(coordinator: AddLocationCoordinating) {
        self.coordinator = coordinator
    }
}

extension AddLocationPresenter: AddLocationPresenting {
    func presentPostLocationViewController(_ location: String, _ mediaURL: String, _ coordinates: (Double, Double)) {
        coordinator.presentPostLocationViewController(location, mediaURL, coordinates)
    }
    
    func displayError(_ error: String) {
        viewController?.displayError(error)
    }
    
    func startLoading() {
        viewController?.startLoadingView()
    }
    
    func stopLoading() {
        viewController?.stopLoadingView()
    }
}
