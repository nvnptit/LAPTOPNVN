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
    static let baseUrl: String = "http://192.168.1.12" //2.19
    
    //get -> fetch
    public static func getDoanhThu(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[DoanhThuResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[DoanhThuResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getNV(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[EmployeeModel]>?, String?) -> ()) {
        APIController.request(ResponseBase<[EmployeeModel]>.self, manager, params: params, headers: headers) { error, data in
            if let dataNV = data {
                completion(dataNV, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getHistoryOrder(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrder]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrder]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func postRegister(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func postUser(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<User>?, String?) -> ()) {
        APIController.request(ResponseBase<User>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func updateUser(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func delTK(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func postLogin(with manager: APIManager, _ params: [String: Any], _ headers: HTTPHeaders?, completion: @escaping(ResponseBase<LoginRes>?, String?) -> ()) {
        APIController.request(ResponseBase<LoginRes>.self, manager, params: params, headers: headers) { error, data in
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
    public static func updateGioHang(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    
    //get -> fetch
    public static func deleteGioHang(with manager: APIManager,  params: Parameters?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
            if let dataL = data {
                completion(data, nil)
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


