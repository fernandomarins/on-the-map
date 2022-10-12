//
//  Alerttable.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

protocol Alertable: AnyObject {
    
    func showAlert(title: String, message: String)
}

class AlertViewController: Alertable {
    weak var viewController: UIViewController?
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}

