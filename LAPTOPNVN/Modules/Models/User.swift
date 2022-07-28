//
//  User.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import Foundation
struct User : Decodable{
    let cmnd, email, ten, diachi: String?
    let ngaysinh, sdt, tendangnhap: String?
}
struct UserModel : Encodable{
    let cmnd, email, ten, diachi: String?
    let ngaysinh, sdt, tendangnhap: String?
}
