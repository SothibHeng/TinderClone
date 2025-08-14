//
//  BottomControllerSdtackView.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

class HomeBottomControlStackView: UIStackView {
    
    static func createButton(imageName: String, size: CGSize) -> UIButton {
        let button = UIButton(type: .system)
        
        if let image = UIImage(named: imageName)?.resize(to: size) {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            print("Warning: Image '\(imageName)' not found.")
        }
        
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }
    
    let refreshButtomView = createButton(
        imageName: "refresh",
        size: CGSize(width: 23, height: 23)
    )
    
    let closeButtomView = createButton(
        imageName: "close",
        size: CGSize(width: 20, height: 20)
    )
    
    let starButtomView = createButton(
        imageName: "star",
        size: CGSize(width: 26, height: 26)
    )
    
    let heartButtomView = createButton(
        imageName: "heart",
        size: CGSize(width: 30, height: 30)
    )
    
    let lightingButtomView = createButton(
        imageName: "lighting",
        size: CGSize(width: 29, height: 29)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeSubView(size: CGSize(width: 0, height: 80))
        distribution = .fillEqually
        axis = .horizontal
        alignment = .fill
        
        [refreshButtomView, closeButtomView, starButtomView, heartButtomView, lightingButtomView].forEach { button in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


