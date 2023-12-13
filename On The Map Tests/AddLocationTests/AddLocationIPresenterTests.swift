//
//  AddLocationIPresenterTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

private final class AddLocationViewControllerSpy: AddLocationDisplaying {
    var activityIndicator = LoadingView()
    private(set) var messagesSent: [Messages] = []
    private(set) var error: String?
    
    enum Messages {
        case startLoadingView
        case stopLoadingView
        case displayError
    }
    
    func displayError(_ error: String) {
        messagesSent.append(.displayError)
        self.error = error
    }
    
    func startLoadingView() {
        messagesSent.append(.startLoadingView)
    }
    
    func stopLoadingView() {
        messagesSent.append(.stopLoadingView)
    }
}

private final class AddLocationCoordinatorSpy: AddLocationCoordinating {
    var viewController: UIViewController?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: AddLocationAction?
    
    enum Messages {
        case perform
    }
    
    func perform(action: AddLocationAction) {
        messagesSent.append(.perform)
        self.action = action
    }
}

final class AddLocationIPresenterTests: XCTestCase {
    private let viewControllerSpy = AddLocationViewControllerSpy()
    private let coordinatorSpy = AddLocationCoordinatorSpy()
    
    private var sut: AddLocationPresenting {
        let presenter = AddLocationPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }
    
    func testPresentPostLocation() {
        let location = Location(location: "", mediaURL: "", coordinates: (latitude: 0.0, longitude: 0.0))
        sut.presentPostLocation(action: .presentPost(location: location))
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .presentPost(location: location))
    }
    
    func testShouldDisplayError() {
        sut.displayError("error")
        XCTAssertEqual(viewControllerSpy.messagesSent, [.displayError])
        XCTAssertEqual(viewControllerSpy.error, "error")
    }
    
    func testStartLoading() {
        sut.startLoading()
        XCTAssertEqual(viewControllerSpy.messagesSent, [.startLoadingView])
    }
    
    func testStopLoading() {
        sut.stopLoading()
        XCTAssertEqual(viewControllerSpy.messagesSent, [.stopLoadingView])
    }
    
    func testShouldDismiss() {
        sut.dismiss(action: .dismiss)
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .dismiss)
    }
}
