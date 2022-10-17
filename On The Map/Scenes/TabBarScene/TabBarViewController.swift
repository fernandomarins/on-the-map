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

final class TabBarViewController: UITabBarController {
    
    let interactor: TabBarInteracting
    
    init(interactor: TabBarInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    lazy var activityIndicator = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.tabBarItem.tag)")
    }
}

extension TabBarViewController: TabBarDisplaying {
    func displayError(_ error: String) {
        showAlert(self, error)
    }
}
