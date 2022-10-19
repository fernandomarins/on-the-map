//
//  PostLocationCoordinatorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

final class PostLocationCoordinatorTests: XCTestCase {
    private let viewControllerSpy = ViewControllerSpy()
    
    private var sut: PostLocationCoordinator {
        let coordinator = PostLocationCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }
    
    // TODO: Add test for the coordinator
}
