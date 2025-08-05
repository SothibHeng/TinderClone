//
//  RegistrationController.swift
//  DatingApp
//
//  Created by Universe on 4/8/25.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    let selectPhotoButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.widthAnchor.constraint(equalToConstant: 280).isActive = true
        button.heightAnchor.constraint(equalToConstant: 280).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let usernameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Username"
        textField.textContentType = .username
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Email"
        textField.textContentType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()
    
    let registrationButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registration", for: .normal)
        button.backgroundColor = .whiteSmoke
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handleRegistrationButton), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailTextField,
            passwordTextField,
            registrationButtomView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButtomView,
        verticalStackView
    ])
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        overallStackView.bringSubviewToFront(overallStackView)
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    @objc fileprivate func handleRegistrationButton() {
        self.handleTapDismiss()
        print("Register user to Firebase Auth!")
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            
            guard let uid = res?.user.uid else {
                       print("User UID not found")
                       return
                   }

            print("Successfully registered user with uid: \(uid)")
            
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed to registered."
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self] isFormValid in
            print("Is form is valid and it's change? \(isFormValid)")
            
            
            self.registrationButtomView.isEnabled = isFormValid
            
            if isFormValid {
                self.registrationButtomView.backgroundColor = UIColor(red: 207/255, green: 26/255, blue: 85/255, alpha: 1.0)
                self.registrationButtomView.setTitleColor(.white, for: .normal)
                registrationButtomView.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            } else {
                self.registrationButtomView.backgroundColor = .whiteSmoke
                self.registrationButtomView.setTitleColor(.gray, for: .normal)
                self.registrationButtomView.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("username canBecomeFirstResponder: \(self.usernameTextField.canBecomeFirstResponder)")
            print("email canBecomeFirstResponder: \(self.emailTextField.canBecomeFirstResponder)")
            print("password canBecomeFirstResponder: \(self.passwordTextField.canBecomeFirstResponder)")
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == usernameTextField {
            print("Username Changing!")
            registrationViewModel.username = textField.text
        } else if textField == emailTextField {
            print("Email Changing!")
            registrationViewModel.email = textField.text
        } else {
            print("Password Changing!")
            registrationViewModel.password = textField.text
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        overallStackView.axis = .vertical
        overallStackView.spacing = 10
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        selectPhotoButtomView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(overallStackView)

        NSLayoutConstraint.activate([
            selectPhotoButtomView.widthAnchor.constraint(equalToConstant: 280),
            selectPhotoButtomView.heightAnchor.constraint(equalToConstant: 280),

            overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
         
    }
        
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.secondaryColor.cgColor, UIColor.primaryColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleKeyboardShowUp(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y:  -difference - 10)
    }
}
