//
//  Services.swift
//  DatingApp
//
//  Created by Universe on 12/8/25.
//

import UIKit
import Firebase

class Services {
    static func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
                
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch current user:", err)
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            
            let user = User(dictionary: data)
            completion(user)
        }
    }
}
