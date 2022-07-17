//
//  TabItems.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

import UIKit

enum TabItem: String, CaseIterable {
    case shop = "Shop"
    case explore = "Explore"
    case cart = "Cart" 
    case account = "Account"

    var viewController: UIViewController {
        switch self {
        case .shop:
            return HomeViewController()
        case .explore:
            return ExplorerViewController()
        case .cart:
            return CartViewController()
        case .account:
            return AccountViewController()
        }
    }

    var icon: UIImage {
        switch self {
        case .shop:
            return UIImage(named: "shop")!
        case .explore:
            return UIImage(named: "explorer")!
        case .cart:
            return UIImage(named: "cart")!
        case .account:
            return UIImage(named: "person")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
