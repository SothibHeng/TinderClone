//
//  BaseNavControllers.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

class HomeScreenController: UIViewController {
    
    let topStackView = HomeTopControlStackView()
    
    let cardSwapView = UIView()

    let bottomStackView = HomeBottomControlStackView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(
                name: "Universe",
                profession: "Singer",
                imageNames: ["dummyImage1", "dummyImage2", "dummyImage3"],
                age: 23
            ),
            
            User(
                name: "Moon",
                profession: "Teacher",
                imageNames: ["cat1", "cat2", "cat3"],
                age: 34
            ),
            
            Advertiser(
                title: "Card is out of menu",
                brandName: "Another Universe",
                photoPosterName: "cute-cat"
            ),
            
            User(
                name: "Universe",
                profession: "Singer",
                imageNames: ["dummyImage1", "dummyImage2", "dummyImage3"],
                age: 23
            ),
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map { producer -> CardViewModel in
            return producer.toCardViewModel()
        }
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        topStackView.userButtonView.addTarget(self, action: #selector(handleuserSetting), for: .touchUpInside)
                
        setupLayout()
        setupCard()
    }
    
    @objc func handleuserSetting() {
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    fileprivate func setupCard() {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardSwapView.addSubview(cardView)
            cardView.fillInSuperView()
        }
    }
    
    fileprivate func setupLayout() {
        
        let overallStackView = UIStackView(arrangedSubviews: [
            topStackView, cardSwapView, bottomStackView
        ])
        
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.frame = .init(x: 0, y: 0, width: 300, height: 200)
        
        
        overallStackView.anchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor
        )
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardSwapView)
    }
}

