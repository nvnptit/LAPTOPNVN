//
//  ModelNV.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import Foundation
struct ModelNVResponse: Decodable {
        let manv: String?
        let email: String?
        let ten: String?
        let ngaysinh: String?
        let sdt: String?
        let tendangnhap: String?
}
struct ModelNV: Encodable {
        let manv: String?
}

struct ModelNVEdit: Encodable {
        let manv: String?
        let email: String?
        let ten: String?
        let ngaysinh: String?
        let sdt: String?
        let tendangnhap: String?
}

struct ModelNVResponseAD: Decodable {
        let manv: String?
        let email: String?
        let ten: String?
        let ngaysinh: String?
        let sdt: String?
        let tendangnhap: String?
        let maquyen: Int?
        let tenquyen: String?
        let kichhoat: Bool?
}
