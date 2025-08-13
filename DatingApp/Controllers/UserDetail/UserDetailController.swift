//
//  UserDetailController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailController: UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cute-cat")?.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Universal 40\nDoctor\nSome bio text goes here..."
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.fillInSuperView()
        
        scrollView.addSubview(imageView)
        // frame
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchors(
            top: imageView.bottomAnchor,
            topConstant: 16,
            leading: scrollView.leadingAnchor,
            leadingConstant: 16,
            trailing: scrollView.trailingAnchor,
            trailingConstant: 16,
            bottom: nil
        )
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        print(changeY)
        
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(x: min(0 , -changeY), y: min(0 , -changeY), width: width, height: width)
    }
    
    @objc fileprivate func handleTapDismiss() {
        print("Gature was dismiss!")
        self.dismiss(animated: true)
    }
}

