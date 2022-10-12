//
//  UIViewController+Extensions.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {

    }
    
    func showHideActivityIndicator(show: Bool, activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}
