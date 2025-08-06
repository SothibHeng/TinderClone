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
                print("Image upload failed: \(err)")
                self.bidableIsRegistering.value = false
                self.saveInfoToFirestore(completion: completion)
                return
            }

            ref.downloadURL { url, err in
                self.bidableIsRegistering.value = false
                if let err = err {
                    print("Failed to get download URL: \(err)")
                    self.saveInfoToFirestore(completion: completion)
                    return
                }

                // Optional: You could store the URL in Firestore if needed
                print("Download URL: \(url?.absoluteString ?? "")")
                self.saveInfoToFirestore(completion: completion)
            }
        }
    }

    fileprivate func saveInfoToFirestore(completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["Username": username ?? "", "uid": uid]
        
        print("Saving user info to Firestore with uid: \(uid), username: \(username ?? "")")
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            if let err = err {
                print("Failed to save to Firestore:", err)
                completion(err)
                return
            }
            
            print("Successfully saved user info to Firestore.")
            completion(nil)
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
