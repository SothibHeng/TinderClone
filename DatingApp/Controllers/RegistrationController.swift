//
//  RegistrationController.swift
//  DatingApp
//
//  Created by Universe on 4/8/25.
//

import UIKit
import Firebase
import JGProgressHUD

protocol RegistrationControllerDelegate {
    func didFinishRegistering()
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage

        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    
    var delegate: RegistrationControllerDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = .whiteSmoke
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let subtitlelabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account."
        label.textColor = .whiteSmoke
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let selectPhotoButtomView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.widthAnchor.constraint(equalToConstant: 280).isActive = true
        button.heightAnchor.constraint(equalToConstant: 280).isActive = true
        button.layer.cornerRadius = 16
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhotoButton), for: .touchUpInside)
        return button
    }()
    
    let usernameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "universe"
        textField.textContentType = .username
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
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
    
    let alreadyHaveAnAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Aleady have an account?"
        label.textColor = .whiteSmoke
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let signinButtonView: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(handleSigninButton), for: .touchUpInside)
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
            usernameTextField,
            emailTextField,
            passwordTextField,
            registrationButtomView,
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var signinStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            alreadyHaveAnAccountLabel,
            signinButtonView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
        
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButtomView,
        verticalStackView,
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
        
        self.navigationItem.hidesBackButton = true
    }
    
    @objc fileprivate func handleSelectPhotoButton() {
        print("Photo is selected!")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegistrationButton() {
        self.handleTapDismiss()
        registrationViewModel.performRegistration { [weak self] err in
            if let err = err {
                self?.showHUDWithError(error: err)
            }
            
            print("Finised registering proccess.")
            self?.dismiss(animated: true, completion: {
                self?.delegate?.didFinishRegistering()
            })
        }
    }
    
    @objc fileprivate func handleSigninButton() {
        print("Signin button was taped!")
        let signinController = SigninViewController()
        navigationController?.pushViewController(signinController, animated: true)
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed to upload image."
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self ] isFormValid in
            
            guard let isFormValid = isFormValid else { return }
            
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
        
        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.selectPhotoButtomView.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bidableIsRegistering.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register is Processig"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
        
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == usernameTextField {
            registrationViewModel.username = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
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
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        
        view.addSubview(titleAndSubtitleStackView)
        titleAndSubtitleStackView.anchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: nil
        )
        
        view.addSubview(signinStackView)
        signinStackView.anchors(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor
        )
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
