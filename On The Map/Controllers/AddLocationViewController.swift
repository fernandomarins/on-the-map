//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import SnapKit
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_world")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Post your location"
        label.font = UIFont.systemFont(ofSize: 29)
        return label
    }()
    
    private lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your location"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a link"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(geocode), for: .touchUpInside)
        return button
    }()
    
    private lazy var geocoder = CLGeocoder()
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        setupBarButtons()
    }
    
    // MARK: - Add views
    
    private func addViews() {
        view.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationTextField)
        contentView.addSubview(linkTextField)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(searchButton)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.height.equalTo(100)
            $0.width.equalTo(100)
            $0.centerX.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        
        locationTextField.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(64)
            $0.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        linkTextField.snp.makeConstraints {
            $0.top.equalTo(locationTextField.snp.bottom).offset(12)
            $0.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(linkTextField.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(linkTextField.snp.bottom).offset(64)
            $0.height.equalTo(35)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupBarButtons() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissView))
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    @objc private func geocode() {
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
    
    // Sending data to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let newStudent = Student(createdAt: "", firstName: Client.Auth.firstName, lastName: Client.Auth.lastName, latitude: latitude, longitude: longitude, mapString: locationTextField.text, mediaURL: linkTextField.text, objectId: "", uniqueKey: Client.Auth.uniqueKey, updatedAt: "")
        
        if segue.identifier == "toPost" {
            let vc = segue.destination as! PostLocationViewController
            vc.infoToSend = newStudent
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
}
