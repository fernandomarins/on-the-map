//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Variables
    
    var infoToSend: Student?
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: infoToSend!.latitude ?? 0.0, longitude: infoToSend!.longitude ?? 0.0)
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(infoToSend!.latitude ?? 0.0, infoToSend!.longitude ?? 0.0)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(pin)
    }
    
    // Sending a location to the server    
    @IBAction func submit(_ sender: UIButton) {
        if let infoToSend = infoToSend {
            Client.post(student: infoToSend) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    if let error = error {
                        self.showAlert(title: "Error posting", message: error.localizedDescription)
                    }
                    
                }
            }
        }
        
    }
    
}
