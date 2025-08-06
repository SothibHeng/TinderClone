//
//  RegistrationViewModel.swift
//  DatingApp
//
//  Created by Universe on 5/8/25.
//

import UIKit

class RegistrationViewModel {
    
    var image: UIImage? {
        didSet {
            imageObserver?(image)
        }
    }
    
    var imageObserver: ((UIImage?) -> ())?
    
    var username: String? {
        didSet {
            checkFormValidity()
        }
    }
 
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid =
        username?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        
        isFormValidObserver?(isFormValid)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
    
}
