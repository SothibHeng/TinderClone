//
//  TopControlStackView.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

class HomeTopControlStackView: UIStackView {
    
    let userButtonView = UIButton(type: .system)
    let messageButtonView = UIButton(type: .system)
    let flameButtonView = UIImageView(image: UIImage(named: "flame"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        flameButtonView.sizeSubView(size: CGSize(width: 30, height: 30))
        
        if let userImage = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate) {
            userButtonView.setImage(userImage, for: .normal)
            userButtonView.tintColor = .lightGray
        }
        
        userButtonView.sizeSubView(size: CGSize(width: 28, height: 28))
        
        if let messageImage = UIImage(named: "message")?.withRenderingMode(.alwaysTemplate) {
            messageButtonView.setImage(messageImage, for: .normal)
            messageButtonView.tintColor = .lightGray
        }
        
        messageButtonView.sizeSubView(size: CGSize(width: 30, height: 30))
        
        [userButtonView, flameButtonView, messageButtonView].forEach { value in
            addArrangedSubview(value)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
