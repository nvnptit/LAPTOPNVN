//
//  LoginResponse.swift
//  LAPTOPNVN
//
//  Created by Nhat on 17/07/2022.
//

import Foundation
struct LoginRes: Decodable{
    let cmnd: String?
    let email: String?
    let ten: String?
    let diachi: String?
    let ngaysinh: String?
    let sdt: String?
    let tendangnhap: String?
    
    let manv: String?
    let maquyen:Int?
}

struct LoginResponse: Decodable{
    let cmnd: String?
    let email: String?
    let ten: String?
    let diachi: String?
    let ngaysinh: String?
    let sdt: String?
    let tendangnhap: String?
}
