//
//  TabBarCoordinatorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

final class TabBarCoordinatorTests: XCTestCase {
    private let viewControllerSpy = ViewControllerSpy()
    
    private var sut: TabBarCoordinating {
        let coordinator = TabBarCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }

    func testPerformPresentTabBar() {
        sut.perform(action: .presentAddLocationFlow)
        XCTAssertEqual(viewControllerSpy.callPresentViewControllerCount, 1)
    }
    
//    func testPerformLogout() {
//        sut.perform(action: .logout)
//        XCTAssertEqual(viewControllerSpy.callDismissCount, 1)
//    }
    
    // TODO: Add test for the open link
}
