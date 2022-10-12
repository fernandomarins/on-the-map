//
//  LoginViewControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

class LoginViewControllerFactory {
    
    static func make() -> UIViewController {
        
        let coordinator: LoginCoordinating = LoginCoordinator()
        let presenter: LoginPresenting = LoginPresenter(coordinator: coordinator)
        let interactor: LoginInteracting = LoginInteractor(presenter: presenter)
        
        let viewController = LoginViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "icon_listview-deselected"), tag: 0)
        
        let tableViewController = TableViewController()
        tableViewController.tabBarItem = UITabBarItem(title: "Table", image: UIImage(named: "icon_mapview-deselected"), tag: 1)
        
        let viewControllersList = [mapViewController, tableViewController].map {
            UINavigationController(rootViewController: $0)
        }
        
        tabBarController.setViewControllers(viewControllersList, animated: true)
        tabBarController.modalPresentationStyle = .fullScreen
        
        return tabBarController
    }
}
