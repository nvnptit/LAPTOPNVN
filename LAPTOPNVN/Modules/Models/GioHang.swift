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
    let ngaydukien: String?
    let tonggiatri: Int?
    let matrangthai: Int?
    let cmnd: String?
    let manvgiao: String?
    let manvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: String?
}

struct GioHangEdit : Encodable{
    let idgiohang: Int?
    let ngaylapgiohang: String?
    let ngaydukien: String?
    let tonggiatri: Int?
    let matrangthai: Int?
    let manvgiao: String?
    let manvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: String?
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
//    let serial: String?
//    let idgiohang: Int?
//}

struct GioHangData: Decodable {
    let malsp, tenlsp: String?
    let soluong: Int?
    let anhlsp, mota, cpu, ram: String?
    let harddrive, cardscreen, os: String?
    let mahang: Int?
    let isnew, isgood: Bool?
    let giamoi, ptgg, giagiam: Int?
    let serial: String?
    let idgiohang: Int?
}

struct GioHangModel : Encodable{
        let idgiohang: Int?
        let ngaylapgiohang: String?
        let ngaydukien: String?
        let tonggiatri: Int?
        let matrangthai: Int?
        let cmnd: String?
        let manvgiao: String?
        let manvduyet: String?
        let nguoinhan: String?
        let diachi: String?
        let sdt: String?
        let email: String?
        let malsp: String?
}



struct GioHangResponse : Decodable{
    let success: Bool?
    let message: String?
}

struct GioHangDel : Encodable{
    let idGioHang: Int?
}
