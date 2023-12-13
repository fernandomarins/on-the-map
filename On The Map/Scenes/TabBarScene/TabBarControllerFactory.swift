//
//  TabBarControllerFactory.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import UIKit

enum TabBarControllerFactory {
    static func make() -> UITabBarController {
        let coordinator: TabBarCoordinating = TabBarCoordinator()
        let presenter: TabBarPresenting = TabBarPresenter(coordinator: coordinator)
        let interactor: TabBarInteracting = TabBarInteractor(presenter: presenter)
        
        let tabBarController = TabBarViewController(interactor: interactor)
        
        coordinator.viewController = tabBarController
        presenter.viewController = tabBarController
        
        let mapViewController = MapViewController(interactor: interactor)
        mapViewController.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(named: "icon_listview-deselected"),
            tag: 0
        )
        
        let tableViewController = TableViewController(interactor: interactor)
        tableViewController.tabBarItem = UITabBarItem(
            title: "Table",
            image: UIImage(named: "icon_mapview-deselected"),
            tag: 1
        )
        
        let viewControllersList = [mapViewController, tableViewController].map {
            UINavigationController(rootViewController: $0)
        }
        
        tabBarController.setViewControllers(viewControllersList, animated: true)
        
        return tabBarController
    }
}
