//
//  AddLocationCoordinatorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

final class AddLocationCoordinatorTests: XCTestCase {
    private let viewControllerSpy = ViewControllerSpy()
    
    private var sut: AddLocationCoordinating {
        let coordinator = AddLocationCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }
    
    // TODO: Add test for the coordinator
}
