//
//  PostLocationPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol PostLocationPresenting: AnyObject {
    var viewController: PostLocationDisplaying? { get set }
    func displayError(_ error: String)
    func startLoading()
    func stopLoading()
    func dismiss()
}

class PostLocationPresenter {
    weak var viewController: PostLocationDisplaying?
    private let coordinator: PostLocationCoordinating
    
    init(coordinator: PostLocationCoordinating) {
        self.coordinator = coordinator
    }
}

extension PostLocationPresenter: PostLocationPresenting {
    
    func displayError(_ error: String) {
        viewController?.displayError(error)
    }
    
    func startLoading() {
        viewController?.startLoadingView()
    }
    
    func stopLoading() {
        viewController?.stopLoadingView()
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
}
