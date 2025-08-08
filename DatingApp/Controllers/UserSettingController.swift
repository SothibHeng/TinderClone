//
//  UserSettingController.swift
//  DatingApp
//
//  Created by Universe on 8/8/25.
//

import UIKit

class UserSettingController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        self.navigationItem.hidesBackButton = true
        
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
