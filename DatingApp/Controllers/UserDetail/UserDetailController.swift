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
    
    var cardViewModel: CardViewModel! {
            didSet {
                infoLabel.attributedText = cardViewModel.attributedString
                
                let images: [UIImage] = cardViewModel.imageNames
                    .compactMap { UIImage(named: $0) }
                
                let shuffledImages = images.shuffled()
                
                swappingUserPhotosController = UserDetailSwapPhtotosController(images: shuffledImages)
                
                setupLayout()
                setupVisualBlurEffectView()
            }
        }

    var swappingUserPhotosController = UserDetailSwapPhtotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
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
    
    func createButton(imageName: String, size: CGSize, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        if let image = UIImage(named: imageName)?.resize(to: size) {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            print("Warning: Image '\(imageName)' not found.")
        }
        
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }

    lazy var closeButtomView = createButton(
        imageName: "close",
        size: CGSize(width: 20, height: 20), selector: #selector(handleCloseButton)
    )
    
    lazy var heartButtomView = createButton(
        imageName: "heart",
        size: CGSize(width: 30, height: 30), selector: #selector(handleCloseButton)
    )
    
    lazy var starButtomView = createButton(
        imageName: "star",
        size: CGSize(width: 26, height: 26), selector: #selector(handleCloseButton )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        setupVisualBlurEffectView()
        setupButtonControll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        print(changeY)
        
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        let imageView = swappingUserPhotosController.view!
        imageView.frame = CGRect(x: min(0 , -changeY), y: min(0 , -changeY), width: width, height: width)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = swappingUserPhotosController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillInSuperView()
        
        let swappingView = swappingUserPhotosController.view!
        
        scrollView.addSubview(swappingView)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchors(
            top: swappingView.bottomAnchor,
            topConstant: 16,
            leading: scrollView.leadingAnchor,
            leadingConstant: 16,
            trailing: scrollView.trailingAnchor,
            trailingConstant: 16,
            bottom: nil
        )
        
        scrollView.addSubview(dismissDownArrowButtonView)
        dismissDownArrowButtonView.anchors(
            top: swappingView.bottomAnchor,
            topConstant: 18,
            leading: nil,
            trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
            trailingConstant: 16,
            bottom: nil
        )
        
        dismissDownArrowButtonView.sizeSubView(size: CGSize(width: 28, height: 28))
    }
    
    fileprivate func setupButtonControll() {
        let buttonStackView = UIStackView(arrangedSubviews: [
            closeButtomView, starButtomView, heartButtomView
        ])
        
        view.addSubview(buttonStackView)
        buttonStackView.spacing = 30
        buttonStackView.distribution = .fillEqually
        buttonStackView.anchors(
            top: nil,
            leading: nil,
            trailing: nil,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
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
    
    @objc fileprivate func handleCloseButton() {
        print("Button was taped!")
    }
}

