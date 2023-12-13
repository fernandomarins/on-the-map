//
//  PostLocationInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map
import CoreLocation

private final class PostLocationPresenterSpy: PostLocationPresenting {
    var viewController: PostLocationDisplaying?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: PostLocationAction?
    private(set) var error: String?
    
    enum Messages {
        case displayError
        case openLink
        case startLoading
        case stopLoading
        case dismiss
        case dismissTabBar
    }
    
    func displayError(_ error: String) {
        messagesSent.append(.displayError)
        self.error = error
    }
    
    func startLoading() {
        messagesSent.append(.startLoading)
    }
    
    func stopLoading() {
        messagesSent.append(.stopLoading)
    }
    
    func dismiss(action: PostLocationAction) {
        messagesSent.append(.dismiss)
        self.action = action
    }
    
    func dismissToTabBar(action: PostLocationAction) {
        messagesSent.append(.dismissTabBar)
        self.action = action
    }
}

final class PostLocationInteractorTests: XCTestCase {
    private let presenterSpy = PostLocationPresenterSpy()
    private var serviceMock = NetworkStub(session: URLSession.shared)
    
    private var sut: PostLocationInteracting {
        let interactor = PostLocationInteractor(presenter: presenterSpy,
                                                service: serviceMock)
        return interactor
    }
    
    func testGetUserInfoShouldPass() {
        serviceMock.result = .success(true)
        sut.getUserInfo { _ in
            
        }
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading])
    }
    
    func testGetUserInfoShouldFail() {
        let expectedError: ApiError = .getUserInfoError
        serviceMock.resultCustomError = .failure(expectedError)
        sut.getUserInfo { _ in
            
        }
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                   .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 4.)")
    }
    
    func testPostShouldPass() {
        serviceMock.result = .success(true)
        let location = Location(location: "", mediaURL: "", coordinates: (latitude: 0.0, longitude: 0.0))
        sut.post(location)
        
        // TODO: - It should be .dismissTabBar instead of .dismiss
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                   .stopLoading,
                                                   .dismiss])
        XCTAssertEqual(presenterSpy.action, .dismissTabBar)
    }
    
    func testPostShouldFail() {
        let expectedError: ApiError = .postError
        serviceMock.resultCustomError = .failure(expectedError)
        let location = Location(location: "", mediaURL: "", coordinates: (latitude: 0.0, longitude: 0.0))
        sut.post(location)
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                   .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 5.)")
    }
    
    func testShouldDismiss() {
        sut.dismiss()
        XCTAssertEqual(presenterSpy.messagesSent, [.dismiss])
        XCTAssertEqual(presenterSpy.action, .dismiss)
    }
    
    func testShouldDismissToTabBar() {
        sut.dismissToTabBar()
        XCTAssertEqual(presenterSpy.messagesSent, [.dismissTabBar])
        XCTAssertEqual(presenterSpy.action, .dismissTabBar)
    }
    
}
