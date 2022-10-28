//
//  Province.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/10/2022.
//
// WardElement.swift

import Foundation

enum DivisionTypeProvince: Decodable {
    case thànhPhốTrungƯơng
    case tỉnh
}
// MARK: - ProvinceElement
struct ProvinceElement: Decodable{
    let name: String?
    let code: Int?
    let divisionType: DivisionTypeProvince?
    let codename: String?
    let phoneCode: Int?
    let districts: [District]?
}


