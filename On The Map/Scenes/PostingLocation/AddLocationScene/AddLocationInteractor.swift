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

final class AddLocationInteractor {
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
        service.geocodeLocation(location) { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success(let placemark):
                let coordinates: CLLocationCoordinate2D = placemark.coordinate
                let location: Location = Location(
                    location: location,
                    mediaURL: mediaURL,
                    coordinates: (coordinates.latitude, coordinates.longitude)
                )
                self?.presenter.presentPostLocation(action: .presentPost(location: location))
            case .failure(let error):
                self?.presenter.displayError(error.localizedDescription)
                return
            }
        }
    }
    
    func dismiss(action: AddLocationAction) {
        presenter.dismiss(action: .dismiss)
    }
}
