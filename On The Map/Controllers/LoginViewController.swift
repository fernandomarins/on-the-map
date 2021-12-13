//
//  ViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Login
    
    @IBAction func login(_ sender: UIButton) {
        showHideActivityIndicator(show: true, activityIndicator: activityIndicator)
        print(usernameTextField.text!)
        Client.login(username: usernameTextField.text!, password: passwordTextField.text!, completion: handleSessionResponse(success:error:))
    }
    
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            Client.getUserInfo { success, error in
                if success {
                    self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                    self.performSegue(withIdentifier: "login", sender: nil)
                } else {
                    if let error = error {
                        self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        } else {
            if let error = error {
                self.showHideActivityIndicator(show: false, activityIndicator: self.activityIndicator)
                showAlert(title: "Error login", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
