//
//  PostLocationPresenterTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 19/10/22.
//

import XCTest
@testable import On_The_Map

private final class PostLocationViewControllerSpy: PostLocationDisplaying {
    var activityIndicator = LoadingView()
    private(set) var messagesSent: [Messages] = []
    private(set) var error: String?
    
    enum Messages {
        case startLoadingView
        case stopLoadingView
        case displayError
        case dismiss
        case dismissTabBar
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

private final class PostLocationCoordinatorSpy: PostLocationCoordinating {
    var viewController: UIViewController?
    private(set) var messagesSent: [Messages] = []
    private(set) var action: PostLocationAction?
    
    enum Messages {
        case perform
    }
    
    func perform(action: PostLocationAction) {
        messagesSent.append(.perform)
        self.action = action
    }
}

final class PostLocationIPresenterTests: XCTestCase {
    private let viewControllerSpy = PostLocationViewControllerSpy()
    private let coordinatorSpy = PostLocationCoordinatorSpy()
    
    private var sut: PostLocationPresenting {
        let presenter = PostLocationPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
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
    
    func testShouldDismissTabBar() {
        sut.dismissToTabBar(action: .dismissTabBar)
        
        XCTAssertEqual(coordinatorSpy.messagesSent, [.perform])
        XCTAssertEqual(coordinatorSpy.action, .dismissTabBar)
    }
}
