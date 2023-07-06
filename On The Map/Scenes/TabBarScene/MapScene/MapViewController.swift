//
//  MapViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import UIKit
import MapKit
import SnapKit

final class MapViewController: TabBarViewController, MKMapViewDelegate {
    
    // MARK: - Variables
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        setupBarButtons()
        getPins()
        addNotification()
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
            $0.edges.equalTo(contentView.snp.edges)
        }
    }
    
    // MARK: - Private methods
    
    private func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .done,
            target: self,
            action: #selector(logout)
        )
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refresh)
        )
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(presentAddLocationView)
        )
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    @objc private func refresh() {
        getPins()
    }
    
    @objc private func logout() {
        interactor.logout()
    }
    
    // Getting all the pins
    private func getPins() {
        interactor.getAllLocations { [weak self] success in
            if success {
                self?.addPinsToMap()
            }
        }
    }
    
    @objc private func addPinsToMap() {
        // Removing the old pins before adding new ones
        mapView.removeAnnotations(mapView.annotations)
        
        guard !StudentList.allStudents.isEmpty else {
            return
        }
        
        StudentList.allStudents.forEach {
            let pin = createAnnotation(for: $0)
            mapView.addAnnotation(pin)
        }
    }
    
    @objc private func presentAddLocationView() {
        interactor.presentAddLocation()
    }
    
    private func createAnnotation(for student: Student) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = student.firstName
        pin.subtitle = student.mediaURL
        pin.coordinate = CLLocationCoordinate2D(
            latitude: student.latitude ?? 0.0,
            longitude: student.longitude ?? 0.0
        )
        return pin
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: Notification.Name("update"),
            object: nil
        )
    }
    
    // MARK: - MapView delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle,
            let unwrappedOpen = toOpen {
                guard UIApplication.shared.canOpenURL(URL(string: unwrappedOpen) ?? URL(fileURLWithPath: "")) else {
                    showAlert(self, "The link is not valid")
                    return
                }
                interactor.openLink(unwrappedOpen)
            }
        }
    }
}
