//
//  Extension.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIButton {
    
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        self .init(arrangedSubviews: arrangedSubviews)
        self.spacing = spacing
    }
}


//extension UIImage {
//    
//    func resize(to size: CGSize) -> UIImage? {
//        
//        let renderer = UIGraphicsImageRenderer(size: size)
//        
//        return renderer.image { _ in
//            self.draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
//}

extension UIColor {
    
    static var whiteSmoke: UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    }
    
    static var titleColor: UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    
    static var subtitleColor: UIColor {
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    
    static var primaryColor: UIColor {
        return UIColor(red: 226/255, green: 28/255, blue: 116/255, alpha: 1)
    }
    
    static var secondaryColor: UIColor {
        return UIColor(red: 250/255, green: 94/255, blue: 93/255, alpha: 1)
    }
}

extension UIView {
    func sizeSubView(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}

