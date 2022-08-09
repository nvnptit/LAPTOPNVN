//
//  DoanhThuModel.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import Foundation

// MARK: - DoanhThuModel
struct DoanhThuResponse: Decodable {
    var thang: Int?
    var nam: Int?
    var doanhthu: Int?
}

struct DoanhThuModel: Encodable {
    let dateFrom: String?
    let dateTo: String?
}
