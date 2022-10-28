//
//  District.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/10/2022.
//

// District.swift
import Foundation

// DivisionType.swift

enum DivisionType : Decodable {
    case huyện
    case quận
    case thànhPhố
}


// MARK: - District
struct District : Decodable {
    let name: String?
    let code: Int?
    let divisionType, codename: String?
    let phoneCode: Int?
    let districts: [DistrictElement]?
}


// MARK: - DistrictElement
struct DistrictElement : Decodable {
    let name: String?
    let code: Int?
    let divisionType: DivisionType?
    let codename: String?
    let provinceCode: Int?
    let wards: [Ward]?
}
