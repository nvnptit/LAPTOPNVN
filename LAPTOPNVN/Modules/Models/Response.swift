//
//  Response.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import Foundation
struct TaiKhoan : Encodable {
    let tendangnhap: String?
    let matkhau: String?
    let maquyen: Int?
}
struct Response : Decodable{
    let success: Bool?
    let message: String?
}

struct ResponseSL : Decodable{
    let success: Bool?
    let message: Int?
}
