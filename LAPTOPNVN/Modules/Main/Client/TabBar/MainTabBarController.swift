//
//  MainTabBarController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    var customTabBar: CustomTabBar!
    var tabBarHeight: CGFloat = 67.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.loadTabBar()
    }
    
    func loadTabBar() {
        // Tạo và load custom tab bar
        let tabbarItems: [TabItem] = [.shop, .explore, .cart, .account]
        
        setupCustomTabMenu(tabbarItems) { viewControllers in
            self.viewControllers = viewControllers
        }
        selectedIndex = 0 // Set default selected index thành item đầu tiên
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        // Handle custom tab bar và các attach touch event listener
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        // Ẩn tab bar mặc định của hệ thống đi
        tabBar.isHidden = true
        // Khởi tạo custom tab bar
        customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        view.addSubview(customTabBar)
        view.backgroundColor = .white
        
        // Auto layout cho custom tab bar
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Thêm các view controller tương ứng
        menuItems.forEach({
            controllers.append($0.viewController)
        })
        
        view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        selectedIndex = tab
    }
}
