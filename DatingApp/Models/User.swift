//
//  User.swift
//  DatingApp
//
//  Created by Universe on 29/7/25.
//
import UIKit

struct User: ProducesCardViewModel {
    let name: String
    let profession: String
    let imageNames: [String]
    let age: Int
    
    init(dictionary: [String: Any]) {
        let name = dictionary["Username"] as? String ?? " "
        self.age = 0
        self.profession = "Job Profession"
        self.name = name
        self.imageNames = []
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(
            string: name,
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .bold)]
        )
        
        attributedText.append(NSMutableAttributedString(
            string: "  \(age)",
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .regular)]
        ))
        
        attributedText.append(NSMutableAttributedString(
            string: "\n\(profession)",
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]
        ))
          
        return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left )
    }
}

