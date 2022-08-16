//
//  TyGia.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/08/2022.
//

import Foundation

// MARK: - TyGiaResponse
struct TyGiaResponse: Decodable {
    let matg: String?
    let ngayapdung: String?
    let giatri: Int?
    let manv: String?
}
