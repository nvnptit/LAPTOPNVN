//
//  Double.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/08/2022.
//

import Foundation
extension Double {
    func rounded(toPlaces places:Int) -> String {
        let divisor = pow(10.0, Double(places))
        var returnValue = "\((self * divisor).rounded() / divisor)"
        if(returnValue.split(separator: ".")[1].count == 1 && places > 1)
        { returnValue += "0" }
        return returnValue
    }
}
