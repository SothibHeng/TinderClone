//
//  UserDetailSwapPhtotosController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailSwapPhtotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    let controllers = [
        UserPhotosController(image: UIImage(named: "cute-cat")!),
        UserPhotosController(image: UIImage(named: "cat3")!),
        UserPhotosController(image: UIImage(named: "cat2")!),
        UserPhotosController(image: UIImage(named: "dummyImage1")!),
        UserPhotosController(image: UIImage(named: "dummyImage2")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .cyan

        setViewControllers([controllers.first! ], direction: .forward, animated: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1 ]
    }
}

class UserPhotosController: UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "cute-cat")
        return image
    }()
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillInSuperView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

