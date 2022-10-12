//
//  LoadingViewProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit

protocol LoadingViewProtocol {
    var activityIndicator: UIActivityIndicatorView { get }
    func startLoading()
    func stopLoading()
}

extension LoadingViewProtocol {
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
