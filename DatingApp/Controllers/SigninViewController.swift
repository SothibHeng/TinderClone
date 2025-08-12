//
//  SigninViewController.swift
//  DatingApp
//
//  Created by Universe on 12/8/25.
//

import UIKit
import Firebase
import JGProgressHUD

class SigninViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = .whiteSmoke
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let subtitlelabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back, Please sign in to continue."
        label.textColor = .whiteSmoke
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "universe@gmail.com"
        textField.textContentType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "password"
//        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let signinButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .whiteSmoke
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
    }()
    
    
    let doNotHaveAnAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .whiteSmoke
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let registrationButtonView: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(handleRegistrationButton), for: .touchUpInside)
        return button
    }()
    
    lazy var titleAndSubtitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitlelabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            signinButtomView,
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var signupStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            doNotHaveAnAccountLabel,
            registrationButtonView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
        
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        verticalStackView,
    ])
    
    let gradientLayer = CAGradientLayer()
    let sigginViewModel = SigninViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        overallStackView.bringSubviewToFront(overallStackView)
        
        setupBindables()
        
    }
    
    fileprivate func setupLayout() {
        overallStackView.axis = .vertical
        overallStackView.spacing = 10
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(overallStackView)

        NSLayoutConstraint.activate([

            overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        view.addSubview(titleAndSubtitleStackView)
        titleAndSubtitleStackView.anchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            topConstant: 140,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: nil
        )
        
        view.addSubview(signupStackView)
        signupStackView.anchors(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            bottomConstant: 200
        )
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.secondaryColor.cgColor, UIColor.primaryColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc fileprivate func handleSignin() {
        sigginViewModel.performSignin { [unowned self] err in
            self.loginHUD.dismiss(animated: true)
            if let err = err {
                print("Failed to sigin", err)
                return
            }
            
            print("Sign in successfully!")
            self.dismiss(animated: true)
        }
    }
    
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupBindables() {
        sigginViewModel.isFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self.signinButtomView.isEnabled = isFormValid
            if isFormValid {
                self.signinButtomView.backgroundColor = UIColor(red: 207/255, green: 26/255, blue: 85/255, alpha: 1.0)
                self.signinButtomView.setTitleColor(.white, for: .normal)
                self.signinButtomView.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            } else {
                self.signinButtomView.backgroundColor = .whiteSmoke
                self.signinButtomView.setTitleColor(.gray, for: .normal)
                self.signinButtomView.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            }
        }
        sigginViewModel.isSignin.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Login is processing"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss(animated: true)
            }
        }
    }
    
    @objc fileprivate func handleRegistrationButton() {
        print("Registration Controller!")
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            sigginViewModel.email = textField.text
        } else {
            sigginViewModel.password = textField.text
        }
    }
    
}

