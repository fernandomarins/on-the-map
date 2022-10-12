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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showHideActivityIndicator(show: Bool, activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}
