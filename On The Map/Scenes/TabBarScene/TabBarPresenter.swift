//
//  TabBarPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarPresenting: AnyObject {
    var viewController: TabBarDisplaying? { get set }
    func presentAddLocation()
    func displayError(_ error: String)
    func startLoading()
    func stopLoading()
    func openLink(_ urlString: String)
    func logout()
}

class TabBarPresenter {
    weak var viewController: TabBarDisplaying?
    
    private let coordinator: TabBarCoordinating
    
    init(coordinator: TabBarCoordinating) {
        self.coordinator = coordinator
    }
}

extension TabBarPresenter: TabBarPresenting {
    
    func presentAddLocation() {
        coordinator.perform(action: .presentAddLocationFlow)
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
    
    func openLink(_ urlString: String) {
        coordinator.perform(action: .openLink(urlString))
    }
    
    func logout() {
        coordinator.perform(action: .logout)
    }
}
