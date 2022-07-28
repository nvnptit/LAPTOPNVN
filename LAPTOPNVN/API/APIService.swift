//
//  APIService.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

typealias LoaiSanPhams = [LoaiSanPham]
typealias HangSXs = [HangSX]

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
    public static func getLoaiSanPhamFull(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func getLoaiSanPhamNew(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamKM(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamGood(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamHang(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    //get -> fetch
    public static func searchLoaiSanPham(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    //get -> fetch
    public static func getGioHang(with manager: APIManager,  params: Parameters?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[GioHangData]>?, String?) -> ()) {
        APIController.request(ResponseBase<[GioHangData]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func addGioHangC(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func updateGioHang(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[GioHangResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[GioHangResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func getHangSX(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HangSX]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HangSX]>.self, manager, params: params, headers: headers) { error, data in
            if let dataHangSX = data {
                completion(dataHangSX, nil)
                return
            }
            completion(nil, error)
        }
    }
    
}


