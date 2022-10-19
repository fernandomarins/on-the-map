//
//  AddLocationInteractorTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map
import CoreLocation

private final class AddLocationPresenterSpy: AddLocationPresenting {
    var viewController: AddLocationDisplaying?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: AddLocationAction?
    private(set) var error: String?
    
    enum Messages {
        case presentPostLocation
        case displayError
        case openLink
        case startLoading
        case stopLoading
        case dismiss
    }
    
    func presentPostLocation(action: AddLocationAction) {
        messagesSent.append(.presentPostLocation)
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
    
    func dismiss(action: AddLocationAction) {
        messagesSent.append(.dismiss)
        self.action = action
    }
}

final class AddLocationInteractorTests: XCTestCase {
    private let presenterSpy = AddLocationPresenterSpy()
    private var serviceMock = NetworkStub(session: URLSession.shared)
    
    private var sut: AddLocationInteractor {
        let interactor = AddLocationInteractor(presenter: presenterSpy,
                                               service: serviceMock)
        return interactor
    }
    
    func testGeocodeShouldPass() {
        serviceMock.resultLocation = .success(CLLocation(latitude: 0.0, longitude: 0.0))
        sut.geocode("", "")
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                   .presentPostLocation])
    }
    
    func testGeocodeShouldFail() {
        let expectedError: ApiError = .geocodeError
        serviceMock.resultLocation = .failure(expectedError)
        sut.geocode("", "")
        
        XCTAssertEqual(presenterSpy.messagesSent, [.startLoading,
                                                  .stopLoading,
                                                   .displayError])
        XCTAssertEqual(presenterSpy.error, "The operation couldn’t be completed. (On_The_Map.ApiError error 3.)")
    }
    
    func testShouldCallDismiss() {
        sut.dismiss(action: .dismiss)
        
        XCTAssertEqual(presenterSpy.messagesSent, [.dismiss])
        XCTAssertEqual(presenterSpy.action, .dismiss)
    }
}
