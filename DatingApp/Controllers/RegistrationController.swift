//
//  RegistrationController.swift
//  DatingApp
//
//  Created by Universe on 4/8/25.
//

import UIKit

class RegistrationController: UIViewController {
    
    let selectPhotoButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.sizeSubView(size: CGSize(width: 280, height: 280))
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 16
        return button
    }()
    
    let usernameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Username"
        textField.backgroundColor = .white
        textField.textContentType = .username
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.textContentType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        return textField
    }()
    
    let registrationButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registration", for: .normal)
        button.backgroundColor = UIColor(red: 207/255, green: 26/255, blue: 85/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.sizeSubView(size: CGSize(width: 0, height: 55))
        button.layer.cornerRadius = 26
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
        selectPhotoButtomView.sizeSubView(size: CGSize(width: 280, height: 280))
            
        view.addSubview(overallStackView)
        overallStackView.anchors(
            top: nil,
            leading: view.leadingAnchor,
            leadingConstant: 60,
            trailing: view.trailingAnchor,
            trailingConstant: 60, bottom: nil
        )
        overallStackView.centerYInSuperview()
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
