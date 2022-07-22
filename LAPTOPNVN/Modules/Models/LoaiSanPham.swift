//
//  LoaiSanPham.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
struct LoaiSanPham : Decodable{
    let malsp: String?
    let tenlsp: String?
    let soluong: Int?
    let anhlsp: String?
    let mota: String?
    let cpu: String?
    let ram: String?
    let harddrive: String?
    let cardscreen: String?
    let os: String?
    let mahang: Int?
    let isnew: Bool?
    let isgood: Bool?
    let giamoi: Int?
}

struct LoaiSanPhamKM : Decodable{
    let malsp: String?
    let tenlsp: String?
    let soluong: Int?
    let anhlsp: String?
    let mota: String?
    let cpu: String?
    let ram: String?
    let harddrive: String?
    let cardscreen: String?
    let os: String?
    let mahang: Int?
    let isnew: Bool?
    let isgood: Bool?
    let giamoi: Int?
    let phantramgg: Int?
}
