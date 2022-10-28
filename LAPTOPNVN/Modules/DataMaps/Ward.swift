//
//  Ward.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/10/2022.
//

// Ward.swift

import Foundation

// DivisionType.swift

enum DivisionTypeWard: Decodable{
    case phường
}

// MARK: - Ward
struct Ward: Decodable {
    let name: String?
    let code: Int?
    let divisionType, codename: String?
    let provinceCode: Int?
    let wards: [WardElement]?
}

// MARK: - WardElement
struct WardElement: Decodable {
    let name: String?
    let code: Int?
    let divisionType: DivisionTypeWard?
    let codename: String?
    let districtCode: Int?
}
