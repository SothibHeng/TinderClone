//
//  BaseNavControllers.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit
import Firebase

class HomeScreenController: UIViewController {
    
    let topStackView = HomeTopControlStackView()
    
    let cardSwapView = UIView()

    let bottomStackView = HomeBottomControlStackView()
    
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        topStackView.userButtonView.addTarget(self, action: #selector(handleUserSetting), for: .touchUpInside)
                
        setupLayout()
        setupCard()
        fetchUserFromFireStore()
    }
    
    fileprivate func fetchUserFromFireStore() {
        Firestore.firestore().collection("users").getDocuments { snapsot, err in
            if let err = err {
                print("Falied to fetch user \(err)")
                return
            }
            snapsot?.documents.forEach({ documentSnapsot in
                let userDictionary = documentSnapsot.data()
                let user = User(dictionary: userDictionary)
                
                self.cardViewModels.append(user.toCardViewModel())
            })
            
            self.setupCard()
        }
    }
    
    @objc func handleUserSetting() {
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

