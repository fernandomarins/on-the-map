//
//  PostLocationCoordinatorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

final class PostLocationCoordinatorMock: PostLocationCoordinating {
    var viewController: UIViewController?
    private(set) var performActionCallCount = 0
    private(set) var performedAction: PostLocationAction?
    
    func perform(action: PostLocationAction) {
        performedAction = action
        performActionCallCount += 1
    }
}

final class PostLocationCoordinatorTests: XCTestCase {
    func makeSUT() -> PostLocationCoordinating {
        let sut: PostLocationCoordinating = PostLocationCoordinatorMock()
        return sut
    }
    
    // TODO: Add test for the coordinator
}
