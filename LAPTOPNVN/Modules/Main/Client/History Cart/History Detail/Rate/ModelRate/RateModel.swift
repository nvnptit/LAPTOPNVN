//
//  RateModel.swift
//  LAPTOPNVN
//
//  Created by Nhat on 03/10/2022.
//

import Foundation

struct RateModel: Encodable{
    let cmnd, serial, ngaybinhluan: String?
    let diem: Int?
    let mota: String?
}
struct RateResponse: Decodable {
    let cmnd, serial, ngaybinhluan: String?
    let diem: Int?
    let mota: String?
}

struct RateListResponse: Decodable {
    let ten, ngaybinhluan: String?
    let diem: Int?
    let mota: String?
}
