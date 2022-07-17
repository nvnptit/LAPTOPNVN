//
//  APIService.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

typealias LoaiSanPhams = [LoaiSanPham]
struct APIService {
    public static func postLogin(with manager: APIManager, _ params: [String: Any], _ headers: HTTPHeaders?, completion: @escaping(ResponseBase<LoginResponse>?, String?) -> ()) {
        APIController.request(ResponseBase<LoginResponse>.self, manager, params: params, headers: headers) { error, data in
            if let dataLogin = data {
                completion(dataLogin, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func getLoaiSanPham(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPham]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPham]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func getHangSX(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<HangSX>?, String?) -> ()) {
        APIController.request(ResponseBase<HangSX>.self, manager, params: params, headers: headers) { error, data in
            if let dataHangSX = data {
                completion(dataHangSX, nil)
                return
            }
            completion(nil, error)
        }
    }
    
}


