//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import SnapKit
import UIKit
import MapKit

protocol PostLocationDisplaying: AnyObject, AlertViewProtocol, LoadingViewProtocol {
    func displayError(_ error: String)
}

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    let interactor: PostLocationInteracting
    let coordinates: (latitude: Double, longitude: Double)
    let mediaURL: String
    let location: String
    
    init(interactor: PostLocationInteracting,
         coordinates: (Double, Double),
         mediaURL: String,
         location: String) {
        self.interactor = interactor
        self.coordinates = coordinates
        self.mediaURL = mediaURL
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    lazy var activityIndicator = LoadingView()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()
    
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
        contentView.addSubview(submitButton)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done, target: self,
                                                            action: #selector(dismissView))
    }
    
    @objc private func dismissView() {
        interactor.dismiss()
    }
    
    private func setupMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1)
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(coordinates.0, coordinates.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(pin)
    }
    
    // MARK: - Submitting the location
    @objc private func submit() {
        interactor.getUserInfo { [weak self] success in
            guard let self else { return }
            if success {
                self.interactor.post(self.location,
                                      self.mediaURL,
                                      (self.coordinates.latitude, self.coordinates.longitude))
                self.interactor.dismissAll()
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

extension PostLocationViewController: PostLocationDisplaying {
    func displayError(_ error: String) {
        showAlert(self, "Error", error)
    }
}
