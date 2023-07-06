//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

protocol TabBarDisplaying: AnyObject, AlertViewProtocol, LoadingViewProtocol {
    func displayError(_ error: String)
}

class TabBarViewController: UITabBarController {
    
    let interactor: TabBarInteracting
    
    init(interactor: TabBarInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    lazy var activityIndicator = LoadingView()
}

extension TabBarViewController: TabBarDisplaying {
    func displayError(_ error: String) {
        showAlert(self, error)
    }
}
