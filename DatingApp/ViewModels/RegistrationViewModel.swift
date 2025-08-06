//
//  RegistrationViewModel.swift
//  DatingApp
//
//  Created by Universe on 5/8/25.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
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
        
        bindableIsFormValid.value =  isFormValid
    }
    
    var bindableIsFormValid = Bindable<Bool>(  )

}
