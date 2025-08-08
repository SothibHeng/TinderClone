//
//  UserSettingController.swift
//  DatingApp
//
//  Created by Universe on 8/8/25.
//

import UIKit

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

class UserSettingController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var firstImagebuttonView = createButton(selector: #selector(handleSelectPhoto))
    lazy var secondImagebuttonView = createButton(selector: #selector(handleSelectPhoto))
    lazy var thirdImagebuttonView = createButton(selector: #selector(handleSelectPhoto))
    
    let paddingSize: CGFloat = 16
    let imageButtonViewRadiusSize: CGFloat = 8
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        print("Button eas clicked..!\(button)")
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = imageButtonViewRadiusSize
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .whiteSmoke
        
        self.navigationItem.hidesBackButton = true
        
        setupNavigationItems()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
//        header.backgroundColor = .cyan
        
        header.addSubview(firstImagebuttonView)
        firstImagebuttonView.anchors(
            top: header.topAnchor,
            leading: header.leadingAnchor,
            leadingConstant: paddingSize,
            trailing: nil,
            bottom: header.bottomAnchor
        )
        firstImagebuttonView.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            secondImagebuttonView,
            thirdImagebuttonView
        ])
        
        header.addSubview(verticalStackView)
        verticalStackView.anchors(
            top: header.topAnchor,
            leading: firstImagebuttonView.trailingAnchor,
            leadingConstant: paddingSize,
            trailing: header.trailingAnchor,
            trailingConstant: paddingSize,
            bottom: header.bottomAnchor
        )
         
        verticalStackView.axis = .vertical
        verticalStackView.spacing = paddingSize
        verticalStackView.distribution = .fillEqually
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Svae", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
}
