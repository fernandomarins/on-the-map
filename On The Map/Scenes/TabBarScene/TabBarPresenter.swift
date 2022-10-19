//
//  TabBarPresenter.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation

protocol TabBarPresenting: AnyObject {
    var viewController: TabBarDisplaying? { get set }
    func presentAddLocation(action: TabBarAction)
    func displayError(_ error: String)
    func startLoading()
    func stopLoading()
    func openLink(action: TabBarAction)
    func logout(action: TabBarAction)
}

final class TabBarPresenter {
    weak var viewController: TabBarDisplaying?
    
    private let coordinator: TabBarCoordinating
    
    init(coordinator: TabBarCoordinating) {
        self.coordinator = coordinator
    }
}

extension TabBarPresenter: TabBarPresenting {
    
    func presentAddLocation(action: TabBarAction) {
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
    
    func openLink(action: TabBarAction) {
        coordinator.perform(action: action)
    }
    
    func logout(action: TabBarAction) {
        coordinator.perform(action: action)
    }
}
