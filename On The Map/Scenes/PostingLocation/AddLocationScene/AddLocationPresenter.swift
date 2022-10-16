//
//  AddLocationPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol AddLocationPresenting: AnyObject {
    var viewController: AddLocationDisplaying? { get set }
    func presentPostLocation(action: AddLocationAction)
    func displayError(_ error: String)
    func startLoading()
    func stopLoading()
    func dismiss(action: AddLocationAction)
}

class AddLocationPresenter {
    weak var viewController: AddLocationDisplaying?
    private let coordinator: AddLocationCoordinating
    
    init(coordinator: AddLocationCoordinating) {
        self.coordinator = coordinator
    }
}

extension AddLocationPresenter: AddLocationPresenting {
    func presentPostLocation(action: AddLocationAction) {
        coordinator.perform(action: action)
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
    
    func dismiss(action: AddLocationAction) {
        coordinator.perform(action: action)
    }
}
