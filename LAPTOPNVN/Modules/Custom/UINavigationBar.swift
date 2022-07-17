//
//  UINavigationBar.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
class UINavBar: UINavigationController{
    static func clear(_ view : UINavigationItem){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            view.compactAppearance = appearance
            view.scrollEdgeAppearance = appearance
            view.standardAppearance = appearance
        } else {
        }
    }
}
