//
//  UserDetailController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    @objc fileprivate func handleTapDismiss() {
        print("Gature was dismiss!")
        self.dismiss(animated: true)
    }
}

