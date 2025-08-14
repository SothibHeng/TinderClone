//
//  BaseNavControllers.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeScreenController: UIViewController, UserSettingControllerDelegate, SigninControllerDelegate, CardViewDelegate {
    
    let topStackView = HomeTopControlStackView()
    
    let cardSwapView = UIView()

    let bottomControls = HomeBottomControlStackView()
    
    
    var cardViewModels = [CardViewModel]()
    
    var lastFetchedUser: User?
    
    fileprivate var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        topStackView.userButtonView.addTarget(self, action: #selector(handleUserSetting), for: .touchUpInside)
        
        bottomControls.refreshButtomView.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        bottomControls.heartButtomView.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        bottomControls.closeButtomView.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
                
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Home controller view did appear!!!")
        if Auth.auth().currentUser == nil {
            let signInController = SigninViewController()
            signInController.delegate = self
            let navController = UINavigationController(rootViewController: signInController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
    
    func didFinishSigingIn() {
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        Services.fetchCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.user = user
            print("Fetched current user:", user ?? "nil")
            self.fetchUserFromFirestore()
        }
    }
    
    fileprivate func fetchUserFromFirestore() {
                
        let minAge = user?.minAge ?? UserSettingController.defaultMinAge
        let maxAge = user?.maxAge ?? UserSettingController.defaultMaxAge
        

        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetch User"
        hud.show(in: view)

        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        cardSwapView.subviews.forEach{($0.removeFromSuperview())} // clear old card after save user setting
        query.getDocuments { snapsot, err in
            hud.dismiss()
            if let err = err {
                print("Falied to fetch user \(err)")
                return
            }
            
            var previousCardView: CardView?
            
            snapsot?.documents.forEach({ documentSnapsot in
                let userDictionary = documentSnapsot.data()
                let user = User(dictionary: userDictionary)
                // handle not to show current user show up on card
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUserFromFirestore()
    }
    
    var topCardView: CardView?
    
    let duration = 0.5

    @objc fileprivate func handleLike() {
        print("Like button was clicked!")
        saveSwapeToFirestore(didLike: 1)
        performSwapping(traslation: 700, angle: 15)
    }
    
    fileprivate func saveSwapeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let documentData = [cardUID: didLike]
        
        // get swipes from firestore before update
        Firestore.firestore().collection("swapes").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch swipes data from firestore!")
                return
            }
            print("Successfully fetch swipes data from firestore!")
            
            // check if data exist then update else set swipes back to store
            if snapshot?.exists == true {
                // update data instead
                Firestore.firestore().collection("swapes").document(uid).updateData(documentData) { err in
                    if let err = err {
                        print("Failed to updated swipes information to firestore!", err)
                        return
                    }
                    print("Successfully updated swapes information to firestore!")
                }
            } else {
                Firestore.firestore().collection("swapes").document(uid).setData(documentData) { err in
                    if let err = err {
                        print("Failed to save swapes information", err)
                        return
                    }
                    print("Successfully save swaped information!!")
                }
            }
        }
    }
    
    @objc fileprivate func handleDislike() {
        print("Dislike button was clicked!")
        saveSwapeToFirestore(didLike: 0)
        performSwapping(traslation: -700, angle: -15)
    }
    
    fileprivate func performSwapping(traslation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = traslation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
        cardView.removeFromSuperview()
        self.topCardView = cardView.nextCardView
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardSwapView.addSubview(cardView)
        cardSwapView.sendSubviewToBack(cardView)
//        cardSwapView.bringSubviewToFront(cardView)
        cardView.fillInSuperView()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        print("Home controller:\(cardViewModel.attributedString)")
        let userDetailController = UserDetailController()
        userDetailController.cardViewModel = cardViewModel
        userDetailController.modalPresentationStyle = .fullScreen
        present(userDetailController, animated: true)
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

