//
//  Sale.swift
//  LAPTOPNVN
//
//  Created by Nhat on 30/09/2022.
//

import Foundation
struct Sale: Decodable {
    let madotgg: String?
    let ngaybatdau: String?
    let ngayketthuc: String?
    let mota: String?
    let manv: String?
}

struct SaleDel: Encodable {
    let madotgg: String?
}

struct SaleModel: Encodable {
    let madotgg: String?
    let ngaybatdau: String?
    let ngayketthuc: String?
    let mota: String?
    let manv: String?
}

struct ResponseDetailSale: Decodable {
    let malsp, madotgg: String?
    let phantramgg: Int?
}

struct DetailSaleModel: Encodable {
    let malsp, madotgg: String?
    let phantramgg: Int?
}

struct DetailSaleModelDelete: Encodable {
    let malsp, madotgg: String?
}
