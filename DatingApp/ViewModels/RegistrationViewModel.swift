//
//  RegistrationViewModel.swift
//  DatingApp
//
//  Created by Universe on 5/8/25.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bidableIsRegistering = Bindable<Bool>()
    
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
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email else { return }
        guard let password = password else { return }
        
        bidableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            
            if let err = err {
                completion(err)
                return
            }
            
            guard let uid = res?.user.uid else {
                       print("User UID not found")
                       return
                   }

            print("Successfully registered user with uid: \(uid)")
            
            self.saveImageToFirebase(completion: completion)
            
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil) { _, err in
            if let err = err {
                completion(err)
                return
            }
            print("Finised upload image to store.")
            ref.downloadURL { url, err in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bidableIsRegistering.value = false
                print("Downlaod URL of image is: ", url?.absoluteString ?? " ")
            }
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid =
        username?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        
        bindableIsFormValid.value =  isFormValid
    }
}
