//
//  ViewControllerSpy.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 14/10/22.
//

import UIKit

final class ViewControllerSpy: UIViewController {
    public private(set) var presentViewControllerInvocations: [UIViewController] = []
    public private(set) var showViewControllerInvocations: [UIViewController] = []
    
    public private(set) var callDismissCount = 0
    public private(set) var callPresentViewControllerCount = 0
    public private(set) var callShowViewControllerCount = 0
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        callDismissCount += 1
    }
    
    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        callPresentViewControllerCount += 1
        presentViewControllerInvocations.append(viewControllerToPresent)
    }
    
    override public func show(_ viewControllerToPresent: UIViewController, sender: Any?) {
        callShowViewControllerCount += 1
        showViewControllerInvocations.append(viewControllerToPresent)
    }
}
