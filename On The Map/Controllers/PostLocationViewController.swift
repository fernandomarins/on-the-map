//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import SnapKit
import UIKit
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()
    
    lazy var latitude = CLLocationDegrees()
    lazy var longitude = CLLocationDegrees()
    lazy var location = String()
    lazy var link = String()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addViews()
        addConstraints()
        setupBarButtons()
        
        setupMap()
    }
    
    // MARK: - Add views
    
    private func addViews() {
        view.addSubview(contentView)
        contentView.addSubview(mapView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(submitButton)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Private methods
    
    private func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done, target: self,
                                                            action: #selector(dismissView))
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    private func setupMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(pin)
    }
    
    // MARK: - Submitting the location
    @objc private func submit() {
        showHideActivityIndicator(show: true, activityIndicator: activityIndicator)
        let postLocation = PostLocation(uniqueKey: Client.Auth.uniqueKey,
                                        firstName: Client.Auth.firstName,
                                        lastName: Client.Auth.lastName,
                                        mapString: location,
                                        mediaURL: link,
                                        latitude: latitude,
                                        longitude: longitude)
        
        Client.post(student: postLocation) { [weak self] success, error in
            guard let self else { return }
            if success {
                DispatchQueue.main.async {
                    self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                    NotificationCenter.default.post(name: Notification.Name("update"), object: nil)
                    self.dismissView()
                }
            } else {
                if let error {
                    self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                    self.showAlert(title: "Error posting", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - MapView delegate method
    
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
    
}
