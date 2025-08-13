//
//  UserDetailController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            // render autaul image from CardView
            
        }
    }
    
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
    
    let dismissDownArrowButtonView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissArrowDownButton), for: .touchUpInside)
        return button
    }()
    
    // create button
    
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
    
    let closeButtomView = createButton(
        imageName: "close",
        size: CGSize(width: 20, height: 20)
    )
    
    let heartButtomView = createButton(
        imageName: "heart",
        size: CGSize(width: 30, height: 30)
    )
    
    let starButtomView = createButton(
        imageName: "star",
        size: CGSize(width: 26, height: 26)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        setupVisualBlurEffectView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        print(changeY)
        
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(x: min(0 , -changeY), y: min(0 , -changeY), width: width, height: width)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillInSuperView()
        
        scrollView.addSubview(imageView)
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
        
        scrollView.addSubview(dismissDownArrowButtonView)
        dismissDownArrowButtonView.anchors(
            top: imageView.bottomAnchor,
            topConstant: 18,
            leading: nil,
            trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
            trailingConstant: 16,
            bottom: nil
        )
        
        dismissDownArrowButtonView.sizeSubView(size: CGSize(width: 28, height: 28))
        
        let buttonStackView = UIStackView(arrangedSubviews: [
            closeButtomView, heartButtomView, starButtomView
        ])
        
        scrollView.addSubview(buttonStackView)
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.anchors(
            top: nil,
            leading: nil,
            trailing: nil,
            bottom: scrollView.safeAreaLayoutGuide.bottomAnchor,
            bottomConstant: 80
        )
        buttonStackView.centerXInSuperview()
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchors(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor
        )
    }
    
    @objc fileprivate func handleDismissArrowDownButton() {
        print("Arrow Down Button was dismiss!")
        self.dismiss(animated: true)
    }
}

