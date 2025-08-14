//
//  Advertiser.swift
//  DatingApp
//
//  Created by Universe on 1/8/25.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let photoPosterName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 26, weight: .bold)
        ])
        
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .medium)
        ]))
        
        return CardViewModel(uid: "", imageNames: [photoPosterName], attributedString: attributedString, textAlignment: .center)
    }
}

