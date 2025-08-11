//
//  BaseNavControllers.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeScreenController: UIViewController, UserSettingControllerDelegate  {
    
    let topStackView = HomeTopControlStackView()
    
    let cardSwapView = UIView()

    let bottomControls = HomeBottomControlStackView()
    
    
    var cardViewModels = [CardViewModel]()
    
    var lastFetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        topStackView.userButtonView.addTarget(self, action: #selector(handleUserSetting), for: .touchUpInside)
        
        bottomControls.refreshButtomView.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
                
        setupLayout()
//        setupFirestoreUserCard()
//        fetchUserFromFirestore()
        
        fetchCurrentUser()
        
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            print("Save current user information successfully! \(self.user)")
            self.fetchUserFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUserFromFirestore()
    }
    
    fileprivate func fetchUserFromFirestore() {
        
        guard let minAge = user?.minAge, let maxAge = user?.maxAge else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetch User"
        hud.show(in: view)
//        // fitter fetch only 2 users
//        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? " "]).limit(to:  2)

        // fittler base on user ranging age
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
         
        query.getDocuments { snapsot, err in
            hud.dismiss()
            if let err = err {
                print("Falied to fetch user \(err)")
                return
            }
            snapsot?.documents.forEach({ documentSnapsot in
                let userDictionary = documentSnapsot.data()
                let user = User(dictionary: userDictionary)
                
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardSwapView.addSubview(cardView)
        cardSwapView.sendSubviewToBack(cardView)
        cardView.fillInSuperView()
    }
    
    @objc func handleUserSetting() {
        let userSettingController = UserSettingController()
        userSettingController.delegate = self
        let navController =  UINavigationController(rootViewController: userSettingController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        print("Notified of dismissal from UserSettingController in HomeScreeenController.")
        fetchCurrentUser()
    }
    
    fileprivate func setupFirestoreUserCard() {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardSwapView.addSubview(cardView)
            cardView.fillInSuperView()
        }
    }
    
    fileprivate func setupLayout() {
        
        let overallStackView = UIStackView(arrangedSubviews: [
            topStackView, cardSwapView, bottomControls
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

