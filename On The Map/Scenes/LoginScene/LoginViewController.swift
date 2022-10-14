//
//  ViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import UIKit
import SnapKit

protocol LoginViewDisplyaing: AnyObject, AlertViewProtocol, LoadingViewProtocol {
    func displayError(_ error: String)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let interactor: LoginInteracting
    
    init(interactor: LoginInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Variables
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var udacityLabel: UILabel = {
        let label = UILabel()
        label.text = "UDACITY"
        label.font = UIFont.systemFont(ofSize: 29)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "On The Map"
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator = LoadingView()
    
    private lazy var createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Create one here"
        label.textAlignment = .center
        label.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(openURL))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        
        usernameTextField.text = "f.augustomarins@gmail.com"
        passwordTextField.text = "123Pirralho"
    }
    
    // MARK: - Add views
    
    private func addViews() {
        view.addSubview(contentView)
        contentView.addSubview(udacityLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(createAccountLabel)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        udacityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(udacityLabel.snp.bottom).offset(32)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        
        usernameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(64)
            $0.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(12)
            $0.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(createAccountLabel.snp.top).offset(-26)
            $0.height.equalTo(35)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
        }
        
        createAccountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
    
    // MARK: - Login
    
    @objc private func login() {
        interactor.login(username: usernameTextField.text ?? "",
                         password: passwordTextField.text ?? "")
    }
    
    // MARK: - Tabbar Controller
    
    @objc private func openURL() {
        interactor.openLink()
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: LoginViewDisplyaing {    
    func displayError(_ error: String) {
        showAlert(self, "Error", error)
    }
}
