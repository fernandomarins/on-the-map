//
//  AlertViewProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

protocol AlertViewProtocol: AnyObject {
    func showAlert(_ viewController: UIViewController, _ message: String)
}

extension AlertViewProtocol {
    func showAlert(_ viewController: UIViewController, _ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}

