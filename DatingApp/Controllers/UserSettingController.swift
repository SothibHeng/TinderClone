//
//  UserSettingController.swift
//  DatingApp
//
//  Created by Universe on 8/8/25.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
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
        button.imageView?.layer.cornerRadius = imageButtonViewRadiusSize
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .whiteSmoke
        
        self.navigationItem.hidesBackButton = true
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.keyboardDismissMode = .interactive
        
        setupNavigationItems()
        setupTableHeader()
        fetchCurrentUser()
    }
    
    // case user to instance varible so we can access
    var user: User?
    
    // fetch and show user setting on ui
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print(err)
                return
            }
            
             // fetch data
             guard let dictionary = snapshot?.data() else { return }
             self.user = User(dictionary: dictionary)
            
            self.loadUserPhotos()
            
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        guard let images = user?.imageNames else { return }

        let buttons = [firstImagebuttonView, secondImagebuttonView, thirdImagebuttonView]

        for (index, button) in buttons.enumerated() {
            if index < images.count {
                let imageName = images[index]
                
                if imageName.hasPrefix(" ") {
                    button.sd_setImage(with: URL(string: imageName), for: .normal)
                } else {
                    button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            } else {
                button.setImage(UIImage(named: "No image has found!"), for: .normal)
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = HeaderLabel()
        switch section {
        case 0:
            headerLabel.text = "Name"
        case 1:
            headerLabel.text = "Profession"
        case 2:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserSettingCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 0:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
        case 1:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 2:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    fileprivate func setupTableHeader() {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)

        header.addSubview(firstImagebuttonView)
        firstImagebuttonView.anchors(
            top: header.topAnchor,
            leading: header.leadingAnchor,
            leadingConstant: paddingSize,
            bottom: header.bottomAnchor
        )
        firstImagebuttonView.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true

        let verticalStackView = UIStackView(arrangedSubviews: [
            secondImagebuttonView,
            thirdImagebuttonView
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = paddingSize
        verticalStackView.distribution = .fillEqually

        header.addSubview(verticalStackView)
        verticalStackView.anchors(
            top: header.topAnchor,
            leading: firstImagebuttonView.trailingAnchor,
            leadingConstant: paddingSize,
            trailing: header.trailingAnchor,
            trailingConstant: paddingSize,
            bottom: header.bottomAnchor
        )

        tableView.tableHeaderView = header
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
