//
//  MapViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        getPins()
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        getPins()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Client.logout { success, error in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            } else {
                if let error = error {
                    self.showAlert(title: "Error logout", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getPins() {
        Client.getAllLocations { students, error in
            if students.count == 0 {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            } else {
                self.students = students
                self.addPinsToMap()
            }
        }
    }
    
    func addPinsToMap() {
        mapView.removeAnnotations(mapView.annotations)
        for student in students {
            let pin = MKPointAnnotation()
            pin.title = student.firstName ?? ""
            pin.subtitle = student.mediaURL ?? ""
            pin.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
            mapView.addAnnotation(pin)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}
