//
//  LoginPresenterTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 14/10/22.
//

import XCTest
@testable import On_The_Map

final class LoginPresenterTests: XCTestCase {
    private let viewControllerSpy = ViewControllerSpy()
    
    private var coordinator: LoginCoordinator {
        let coordinator = LoginCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }
    
    private var sut: LoginPresenter {
        let presenter = LoginPresenter(coordinator: coordinator)
        return presenter
    }

    func testPerformPresentTabBar() {
        
    }
}
