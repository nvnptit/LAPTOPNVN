//
//  Color.swift
//  LAPTOPNVN
//
//  Created by Nhat on 15/10/2022.
//

import Foundation
import UIKit
extension UIColor {
    
    static func random() -> UIColor {
        let i = Int.random(in: 0...5)
        switch i {
            case 0:
                return .systemBlue
            case 1:
                return .darkGray
            case 2:
                return .purple
            case 3:
                return .red
            case 4:
                return .brown
            case 5:
                return .systemPink
            default:
                return .blue
        }
    }
    
    static func random2() -> UIColor {
        return UIColor(
           red:  .random(in: 0...1),
           green: .random(in: 0...1),
           blue:  .random(in: 0...1),
           alpha: 1.0
        )
    }
}
