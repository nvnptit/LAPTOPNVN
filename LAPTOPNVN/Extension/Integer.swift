//
//  Integer.swift
//  LAPTOPNVN
//
//  Created by Nhat on 27/07/2022.
//

import Foundation
struct Currency {
    static func toVND(_ price: Int) -> String{
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = ","
            numberFormatter.groupingSize = 3
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.decimalSeparator = "."
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter.string(from: price as NSNumber)! + " VNĐ"
        }
}
