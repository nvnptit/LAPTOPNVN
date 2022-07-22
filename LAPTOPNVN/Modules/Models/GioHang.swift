//
//  GioHang.swift
//  LAPTOPNVN
//
//  Created by Nhat on 22/07/2022.
//

import Foundation

struct GioHangRequest : Encodable{
    let cmnd: String?
}

struct GioHang : Decodable{
    let idgiohang: Int?
    let ngaylapgiohang: String?
    let tonggiatri: Int?
    let matrangthai: Int?
    let cmnd: String?
    let manvgiao: String?
    let manvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: Int?
}

//struct GioHangData : Decodable{
//    let malsp: String?
//    let tenlsp: String?
//    let soluong: Int?
//    let anhlsp: String?
//    let mota: String?
//    let cpu: String?
//    let ram: String?
//    let harddrive: String?
//    let cardscreen: String?
//    let os: String?
//    let mahang: Int?
//    let isnew: Bool?
//    let isgood: Bool?
//    let giamoi: Int?
//    let phantramgg: Int?
//}

struct GioHangData : Decodable{
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
    let serial: String?
    let idgiohang: Int?
}
