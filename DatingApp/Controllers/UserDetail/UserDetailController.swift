//
//  UserDetailController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailController: UIViewController, UIScrollViewDelegate, UserDetailSwapPhotosDelegate {
    func didShowPhoto(at index: Int) {
        for (i, bar) in barViews.enumerated() {
            bar.backgroundColor = (i == index) ? .white : UIColor(white: 1, alpha: 0.3)
        }
    }
    
    fileprivate let extraSwappigHeight: CGFloat = 80
    
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
                swappingUserPhotosController.photosDelegate = self
                
                setupLayout()
                setupVisualBlurEffectView()
                setupBarView()
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
        imageView.frame = CGRect(x: min(0 , -changeY), y: min(0 , -changeY), width: width, height: width + extraSwappigHeight)
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swappingView  = swappingUserPhotosController.view!
        swappingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwappigHeight)
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
    
    fileprivate var barStackView = UIStackView()
    fileprivate var barViews: [UIView] = []

    fileprivate func setupBarView() {
        barStackView.removeFromSuperview()
        
        barStackView = UIStackView()
        barStackView.axis = .horizontal
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
        barViews = []
        for _ in 0..<(cardViewModel.imageNames.count) {
            let bar = UIView()
            bar.backgroundColor = UIColor(white: 1, alpha: 0.3)
            bar.layer.cornerRadius = 2
            bar.clipsToBounds = true
            barViews.append(bar)
            barStackView.addArrangedSubview(bar)
        }
        
        if let firstBar = barViews.first {
            firstBar.backgroundColor = .white
        }
        
        view.addSubview(barStackView)
        barStackView.anchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            topConstant: 8,
            leading: view.leadingAnchor,
            leadingConstant: 8,
            trailing: view.trailingAnchor,
            trailingConstant: 8,
            bottom: nil
        )
        
        barStackView.sizeSubView(size: CGSize(width: 0, height: 4))
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
    
    @objc fileprivate func handleDismissArrowDownButton() {
        print("Arrow Down Button was dismiss!")
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleCloseButton() {
        print("Button was taped!")
    }
}

