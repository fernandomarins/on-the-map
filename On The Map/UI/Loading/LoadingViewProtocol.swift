//
//  LoadingViewProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 12/10/22.
//

import UIKit
import SnapKit

protocol LoadingViewProtocol {
    var activityIndicator: LoadingView { get }
    func startLoadingView()
    func stopLoadingView()
}

protocol LoadingViewOverlayNavigationProtocol: LoadingViewProtocol {
    func startLoadingView()
    func stopLoadingView()
}

extension LoadingViewOverlayNavigationProtocol where Self: UIViewController {
    func startLoadingView() {
        guard let view = navigationController?.view else { return }
        startLoadingView(view: view)
    }
    
    func stopLoadingView() {
        stopLoadingView()
    }
}

extension LoadingViewProtocol where Self: UIViewController {
    func startLoadingView(view: UIView) {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func stopLoadingView(withAnimation: Bool) {
        UIView.animate(withDuration: withAnimation ? 0.3 : 0) { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.alpha = 0
            }
            
        } completion: { [weak self] completed in
            guard completed else { return }
            DispatchQueue.main.async {
                self?.activityIndicator.removeFromSuperview()
            }
        }
    }
    
    func startLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.startLoadingView(view: self.view)
        }
    }
    
    func stopLoadingView() {
        stopLoadingView(withAnimation: true)
    }
}
