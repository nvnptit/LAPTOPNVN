//
//  EmployeeModel.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import Foundation

// MARK: - EmployeeModel
struct EmployeeModel: Decodable {
    var manv, email, ten, ngaysinh: String?
    var sdt, tendangnhap: String?
}
