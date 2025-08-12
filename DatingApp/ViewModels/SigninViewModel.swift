//
//  SigninViewModel.swift
//  DatingApp
//
//  Created by Universe on 12/8/25.
//

import UIKit
import Firebase

class SigninViewModel {
    var isSignin = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? {
        didSet {
            checkFormvaliity()
        }
    }
    
    var password: String? {
        didSet {
            checkFormvaliity()
        }
    }
    
    fileprivate func checkFormvaliity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performSignin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isSignin.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
}
