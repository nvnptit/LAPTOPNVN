//
//  DoanhThuModel.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import Foundation

// MARK: - DoanhThuModel
struct DoanhThuResponse: Decodable {
    let thang: Int?
    let nam: Int?
    let doanhthu: Int?
}

struct DoanhThuModel: Encodable {
    let dateFrom: String?
    let dateTo: String?
}
