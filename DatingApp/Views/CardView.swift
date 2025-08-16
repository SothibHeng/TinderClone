//
//  CardView.swift
//  DatingApp
//
//  Created by Universe on 29/7/25.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView? 
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? " "
            imageView.image = UIImage(named: imageName)
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDesSelectedColor
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, image) in
            print("Changing photo from view model.")
            self?.imageView.image = image
            
            self?.barStackView.arrangedSubviews.forEach { view in
                view.backgroundColor = self?.barDesSelectedColor
            }
            
            self?.barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    private let thresold: CGFloat = 100
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "dummyImage"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel(text: "User Name", font: UIFont.systemFont(ofSize: 24, weight: .bold), textColor: .white, numberOfLines: 0)
    fileprivate let barDesSelectedColor = UIColor(white: 0, alpha: 0.1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    var imageIndex = 0
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        print("Button was taped!!!")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceToNextPhoto = tapLocation.x > frame.width / 2 ? true : false
         
        if shouldAdvanceToNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.backToPreviousPhoto()
        }
    }
    
    fileprivate let seeMoreUserInfoButtonView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "more_info"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(hanleSeeMoreUserInfoButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupLayout() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        addSubview(imageView)
        imageView.fillInSuperView()
        
        setupBarStackView()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.fillSuperViewWithConstants(
            top: nil,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            topConstant: 0,
            leadingConstant: 16,
            trailingConstant: 16,
            bottomConstant: 16
        )
        
        addSubview(seeMoreUserInfoButtonView)
        seeMoreUserInfoButtonView.anchors(
            top: nil,
            leading: nil,
            trailing: trailingAnchor,
            trailingConstant: 16,
            bottom: bottomAnchor,
            bottomConstant: 40
        )
        seeMoreUserInfoButtonView.sizeSubView(size: CGSize(width: 28 , height: 28))
    }
    
    @objc fileprivate func hanleSeeMoreUserInfoButton() {
        print("See more user info button was clicked!")
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismiss = abs(gesture.translation(in: nil).x) > thresold
        
        if shouldDismiss {
            guard let homeController = self.delegate as? HomeScreenController else { return }
            
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.handleDislike()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1) {
                self.transform = .identity
            }
        }
    }

    fileprivate func handleChnaged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTrasform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTrasform.translatedBy(x: translation.x, y: translation.y)
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subview in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChnaged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ( )
        }
    }
    
    fileprivate let barStackView = UIStackView()
    
    fileprivate func setupBarStackView() {
        addSubview(barStackView)
        
        barStackView.fillSuperViewWithConstants(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil,
            topConstant: 8,
            leadingConstant: 8,
            trailingConstant: 8,
            bottomConstant: 0
        )
        
        barStackView.sizeSubView(size: CGSize(width: 0, height: 4))
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

