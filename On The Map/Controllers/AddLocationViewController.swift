//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var geocoder = CLGeocoder()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    func geocode() {
        showHideActivityIndicator(show: true, activityIndicator: activityIndicator)
        geocoder.geocodeAddressString(locationTextField.text!) { placemarks, error in
            
            if let error = error {
                self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks?.first?.location {
                self.latitude = placemarks.coordinate.latitude
                self.longitude = placemarks.coordinate.longitude
                self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                self.performSegue(withIdentifier: "toPost", sender: nil)
            }
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        geocode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let newStudent = Student(createdAt: "", firstName: Client.Auth.firstName, lastName: Client.Auth.lastName, latitude: latitude, longitude: longitude, mapString: locationTextField.text, mediaURL: linkTextField.text, objectId: "", uniqueKey: Client.Auth.uniqueKey, updatedAt: "")
        
        if segue.identifier == "toPost" {
            let vc = segue.destination as! PostLocationViewController
            vc.infoToSend = newStudent
        }
        
    }
        
}
