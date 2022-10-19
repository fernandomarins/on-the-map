//
//  TabBarInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

private final class TabBarPresenterSpy: TabBarPresenting {
    var viewController: TabBarDisplaying?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: TabBarAction?
    private(set) var error: String?
    
    enum Messages {
        case presentAddLocation
        case displayError
        case startLoading
        case stopLoading
        case openLink
        case logout
    }
    
    func presentAddLocation(action: TabBarAction) {
        messagesSent.append(.presentAddLocation)
        self.action = action
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
    
    func openLink(action: TabBarAction) {
        messagesSent.append(.openLink)
        self.action = action
    }
    
    func logout(action: TabBarAction) {
        messagesSent.append(.logout)
        self.action = action
    }
}

final class TabBarInteractorTests: XCTestCase {
    private let presenterSpy = TabBarPresenterSpy()
    private var serviceMock = NetworkStub(session: URLSession.shared)
    
    private var sut: TabBarInteractor {
        let interactor = TabBarInteractor(presenter: presenterSpy,
                                          service: serviceMock)
        return interactor
    }
    
    func testGetAllLocationsShouldPass() {
        serviceMock.result = .success(true)
        
        sut.getAllLocations { _ in
            
        }
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading])
    }
    
    func testGetAllLocationsShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        
        sut.getAllLocations { _ in
            
        }
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testOpenLinkShouldPass() {
        sut.openLink("url_test")
        
        XCTAssertEqual(presenterSpy.messagesSent, [.openLink])
        XCTAssertEqual(presenterSpy.action, .openLink("url_test"))
    }
    
    func testLogoutShouldPass() {
        serviceMock.result = .success(true)
        sut.logout()
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading, .stopLoading, .logout])
        XCTAssertEqual(presenterSpy.action, .logout)
    }
    
    func testLogoutShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        sut.logout()
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testPresentAddLocationFlowShouldPass() {
        sut.presentAddLocation()
        
        XCTAssertEqual(presenterSpy.messagesSent, [.presentAddLocation])
        XCTAssertEqual(presenterSpy.action, .presentAddLocationFlow)
    }
}
