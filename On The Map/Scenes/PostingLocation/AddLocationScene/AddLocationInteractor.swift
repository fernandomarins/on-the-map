//
//  AddLocationInteractor.swift
//  On The Map
//
//  Created by Fernando Marins on 13/10/22.
//

import Foundation
import CoreLocation

protocol AddLocationInteracting: AnyObject {
    func geocode(_ location: String, _ mediaURL: String)
    func dismiss(action: AddLocationAction)
}

class AddLocationInteractor {
    private let service: APIServiceProtocol
    private let presenter: AddLocationPresenting
    
    init(presenter: AddLocationPresenting, service: APIServiceProtocol = APIService()) {
        self.presenter = presenter
        self.service = service
    }
}

extension AddLocationInteractor: AddLocationInteracting {
    func geocode(_ location: String, _ mediaURL: String) {
        presenter.startLoading()
        CLGeocoder().geocodeAddressString(location) { [weak self] placemarks, error in
            self?.presenter.stopLoading()
            if let error {
                self?.presenter.displayError(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks?.first?.location {
                let coordinates: CLLocationCoordinate2D = placemarks.coordinate
                let location: Location = Location(location: location,
                                                  mediaURL: mediaURL,
                                                  coordinates: (coordinates.latitude, coordinates.longitude))
                self?.presenter.presentPostLocation(action: .presentPost(location: location))
            }
        }
    }
    
    func dismiss(action: AddLocationAction) {
        presenter.dismiss(action: .dismiss)
    }
}
