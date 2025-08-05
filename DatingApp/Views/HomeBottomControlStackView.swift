//
//  BottomControllerSdtackView.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

class HomeBottomControlStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageNames = ["close", "heart", "lighting-1", "refresh", "star"]
        
        let imageSizes: [CGSize] = [
            CGSize(width: 21, height: 21),
            CGSize(width: 30, height: 30),
            CGSize(width: 34, height: 34),
            CGSize(width: 27, height: 27),
            CGSize(width: 29, height: 29)
        ]
        
        sizeSubView(size: CGSize(width: 0, height: 80))
        distribution = .fillEqually
        axis = .horizontal
        alignment = .fill
        
        let bottomSubViews = zip(imageNames, imageSizes).map { (imageName, size) -> UIView in
            // Create the button
            let button = UIButton(type: .system)
            if let image = UIImage(named: imageName)?.resize(to: size) {
                button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                print("Image NOT FOUND!!!!!: \(imageName)")
            }
            button.translatesAutoresizingMaskIntoConstraints = false

            let circleView = UIView()
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.backgroundColor = .white
            circleView.layer.cornerRadius = 28
            circleView.layer.shadowColor = UIColor.black.cgColor
            circleView.layer.shadowOpacity = 0.07
            circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
            circleView.layer.shadowRadius = 4
            circleView.clipsToBounds = false
            
            circleView.sizeSubView(size: CGSize(width: 55, height: 55))

            circleView.addSubview(button)
            button.centerInSuperView()
            
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            
            wrapper.addSubview(circleView)
            circleView.centerInSuperView()
            
            return wrapper
        }
        
        bottomSubViews.forEach { view in
            addArrangedSubview(view)
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
