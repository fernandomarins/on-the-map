//
//  TabBarInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

private final class TabBarPresenterSpy: TabBarPresenting {
    
    enum Messages {
        case presentAddLocation
        case displayError
        case startLoading
        case stopLoading
        case openLink
        case logout
    }
    
    private(set) var messagsSent: [Messages] = []
    
    private(set) var action: TabBarAction?
    private(set) var error: String?
    
    var viewController: TabBarDisplaying?
    
    func presentAddLocation(action: TabBarAction) {
        messagsSent.append(.presentAddLocation)
        self.action = action
    }
    
    func displayError(_ error: String) {
        messagsSent.append(.displayError)
        self.error = error
    }
    
    func startLoading() {
        messagsSent.append(.startLoading)
    }
    
    func stopLoading() {
        messagsSent.append(.stopLoading)
    }
    
    func openLink(action: TabBarAction) {
        messagsSent.append(.openLink)
        self.action = action
    }
    
    func logout(action: TabBarAction) {
        messagsSent.append(.logout)
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
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading,
                                                  .stopLoading])
    }
    
    func testGetAllLocationsShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        
        sut.getAllLocations { _ in
            
        }
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testOpenLinkShouldPass() {
        sut.openLink("url_test")
        
        XCTAssertEqual(presenterSpy.messagsSent, [.openLink])
        XCTAssertEqual(presenterSpy.action, .openLink("url_test"))
    }
    
    func testLogoutShouldPass() {
        serviceMock.result = .success(true)
        sut.logout()
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading, .stopLoading, .logout])
        XCTAssertEqual(presenterSpy.action, .logout)
    }
    
    func testLogoutShouldFail() {
        let expectedError: ApiError = .responseError
        serviceMock.result = .failure(expectedError)
        sut.logout()
        
        XCTAssertEqual(presenterSpy.messagsSent, [.startLoading,
                                                  .stopLoading,
                                                  .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 0.)")
    }
    
    func testPresentAddLocationFlowShouldPass() {
        sut.presentAddLocation()
        
        XCTAssertEqual(presenterSpy.messagsSent, [.presentAddLocation])
        XCTAssertEqual(presenterSpy.action, .presentAddLocationFlow)
    }
}
