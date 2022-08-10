//
//  HangSX.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

struct HangSX: Decodable {
    let mahang: Int?
    let tenhang: String?
    let email: String?
    let sdt: String?
    let logo: String?
}

struct HangModel: Encodable {
    let maHang: Int?
}

struct HangSXModel: Encodable {
    let mahang: Int?
    let tenhang: String?
    let email: String?
    let sdt: String?
    let logo: String?
}
