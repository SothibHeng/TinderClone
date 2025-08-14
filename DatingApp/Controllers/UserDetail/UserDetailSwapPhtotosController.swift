//
//  UserDetailSwapPhtotosController.swift
//  DatingApp
//
//  Created by Universe on 13/8/25.
//

import UIKit

class UserDetailSwapPhtotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    var controllers = [UIViewController]()
    
    convenience init(images: [UIImage]) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.controllers = images.map { UserPhotosController(image: $0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .systemBackground
        
        if let first = controllers.first {
            setViewControllers([first], direction: .forward, animated: false)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
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

