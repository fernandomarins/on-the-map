//
//  On_The_Map_Tests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 14/10/22.
//

import XCTest
@testable import On_The_Map

final class LoginCoordinatorTests: XCTestCase {
    private let viewControllerSpy = ViewControllerSpy()
    
    private var sut: LoginCoordinator {
        let coordinator = LoginCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }

    func testPerformPresentTabBar() {
        sut.perform(action: .presentTabBar)
        XCTAssertEqual(viewControllerSpy.callPresentViewControllerCount, 1)
    }
    
    // TODO: Add test for the open link
}
