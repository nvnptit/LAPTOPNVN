//
//  HistoryOrder.swift
//  LAPTOPNVN
//
//  Created by Nhat on 31/07/2022.
//

import Foundation
struct HistoryOrder : Decodable{
    
    let idgiohang: Int?
    let ngaylapgiohang: String?
    let ngaydukien: String?
    let tonggiatri: Int?
    let tentrangthai: String?
    let nvgiao: String?
    let nvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: String?
    let ngaynhan: String?
    let phuongthuc: String?
    let thanhtoan: Bool?
    
    let serial: String?
    let tenlsp: String?
    let anhlsp: String?
    let mota: String?
    let cpu: String?
    let ram: String?
    let harddrive: String?
    let cardscreen: String?
    let os: String?
}

struct HistoryOrder1 : Decodable{
    
    let idgiohang: Int?
    let ngaylapgiohang: String?
    let ngaydukien: String?
    let tonggiatri: Int?
    let tentrangthai: String?
    let nvgiao: String?
    let sdtnvg: String?
    let nvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: String?
    let ngaynhan: String?
    let phuongthuc: String?
    let thanhtoan: Bool?
}

struct HistoryOrder1Detail : Decodable{
    let serial: String?
    let tenlsp: String?
    let anhlsp: String?
    let mota: String?
    let cpu: String?
    let ram: String?
    let harddrive: String?
    let cardscreen: String?
    let os: String?
    let giaban: Int?
}
struct ModelDetailHistory: Encodable {
    let idGioHang: Int?
}

struct HistoryOrderSorted : Decodable{
    let idgiohang: Int?
    let ngaylapgiohang: String?
    let ngaydukien: String?
    let tonggiatri: Int?
    let tentrangthai: String?
    let nvgiao: String?
    let sdtnvg: String?
    let nvduyet: String?
    let nguoinhan: String?
    let diachi: String?
    let sdt: String?
    let email: String?
    let ngaynhan: String?
    let phuongthuc: String?
    let thanhtoan: Bool?
    let km: Float?
}
