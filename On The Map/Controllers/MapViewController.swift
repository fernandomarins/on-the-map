//
//  MapViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Variables
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    var students = [Student]()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        setupBarButtons()
        getPins()
    }
    
    private func addViews() {
        view.addSubview(contentView)
        contentView.addSubview(mapView)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        mapView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
            $0.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    private func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    @objc private func refresh() {
        getPins()
    }
    
    @objc private func logout() {
        Client.logout { [weak self] success, error in
            if success {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            } else {
                if let error {
                    self?.showAlert(title: "Error logout", message: error.localizedDescription)
                }
            }
        }
    }
    
    // Getting all the pins
    
    func getPins() {
        Client.getAllLocations { [weak self] students, error in
            if students.isEmpty {
                if let error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            } else {
                self?.students = students
                self?.addPinsToMap()
            }
        }
    }
    
    func addPinsToMap() {
        // Removing the old pins before adding new ones
        mapView.removeAnnotations(mapView.annotations)
        for student in students {
            let pin = MKPointAnnotation()
            pin.title = student.firstName ?? ""
            pin.subtitle = student.mediaURL ?? ""
            pin.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
            mapView.addAnnotation(pin)
        }
    }
    
    // MARK: - MapView delegate methods
    
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
