//
//  DistrictElement.swift
//  LAPTOPNVN
//
//  Created by Nhat on 15/10/2022.
//

import Foundation

// DivisionType.swift
enum DivisionType {
    case huyện
    case quận
    case thànhPhố
}

// MARK: - DistrictElement
struct DistrictElement {
    let name: String?
    let code: Int?
    let divisionType: DivisionType?
    let codename: String?
    let provinceCode: Int?
    let wards: [Any?]?
}

