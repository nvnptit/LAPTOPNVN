//
//  Laptop.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
struct SanPham: Decodable{
    let serial: String?
    let iddonhang: Int?
    let maphieutra: Int?
    let maphieunhap: Int?
    let malsp: String?
}
struct SLSERI: Decodable{
    let malsp: String?
    let tenlsp: String?
    let soluong: Int?
    let maphieunhap: Int?
    let sl_seri: String?
}

struct PhieuNhap: Decodable{
    let mapn: Int?
    let ngaytao: String?
    let tongtien: Int?
    let madondh: String?
    let manv: String?
}
