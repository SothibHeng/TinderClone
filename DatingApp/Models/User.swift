//
//  User.swift
//  DatingApp
//
//  Created by Universe on 29/7/25.
//
import UIKit

struct User: ProducesCardViewModel {
    var name: String?
    var profession: String?
    var imageNames: [String]?
    var age: Int?
    var uid: String?
    var bio: String?
    
    var minAge: Int?
    var maxAge: Int?
    
    init(dictionary: [String: Any]) {
        if let name = dictionary["username"] as? String {
            self.name = name
        }
        
        if let age = dictionary["age"] as? Int {
            self.age = age
        }
        
        if let profession = dictionary["profession"] as? String {
            self.profession = profession
        }
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        
        if let minAge = dictionary["minAge"] as? Int {
            self.minAge = minAge
        }
        
        if let maxAge = dictionary["maxAge"] as? Int {
            self.maxAge = maxAge
        }

        if let images = dictionary["imageNames"] as? [String], !images.isEmpty {
            self.imageNames = images
        } else {
            let fallbackImages = [ 
                ["dummyImage1", "dummyImage2", "dummyImage3"],
                ["cat1", "cat2", "dummyImage2"],
                ["cute-cat", "cat2", "cat1"],
                ["dummyImage3"],
                ["dummyImage1", "dummyImage2"],
                ["cat1", "cat2", "dummyImage2"],
            ]
            self.imageNames = fallbackImages.randomElement() ?? ["No image found"]
        }
        
        self.uid = dictionary["uid"] as? String ?? "No UID found"
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(
            string: name ?? "",
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .bold)]
        )
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        
        attributedText.append(NSMutableAttributedString(
            string: "  \(ageString)",
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .regular)]
        ))
        
        let professionString = profession != nil ? "\(profession!)" : "Not Provide"
        
        attributedText.append(NSMutableAttributedString(
            string: "\n\(professionString )",
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]
        ))
          
        return CardViewModel(
            imageNames: imageNames ?? [],
            attributedString: attributedText,
            textAlignment: .left
        )
    }
}

