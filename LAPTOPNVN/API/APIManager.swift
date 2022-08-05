//
//  APIManager.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

enum APIManager {
    case login
    case register
    case resetPass
    
    case addUser
    case updateUser
    
    case getHangSX
    case getLoaiSanPhamFull
    case getLoaiSanPhamNew
    case getLoaiSanPhamKM
    case getLoaiSanPhamGood
    case getLoaiSanPhamHang
    case searchLSP
    case delTK
    
    case addGioHang
    case getGioHang
    case updateGioHang
    case deleteGioHang
    
    case getHistoryOrder
    
}

extension APIManager {
    var baseURL: String  { return "\(APIService.baseUrl)/api"}
    //MARK: - URL
    var url: String {
        var path = ""
        //        let version = "/v1"
        switch self {
            case .login: path = "/tai-khoan/login"
            case .register: path = "/tai-khoan"
            case .resetPass: path = "/tai-khoan/thay-matkhau"
                
            case .getHangSX:
                path = "/hang-sx"
            case .getLoaiSanPhamFull:
                path = "/loai-san-pham"
            case .getLoaiSanPhamNew:
                path = "/loai-san-pham/get-new-lsp"
            case .getLoaiSanPhamKM:
                path = "/loai-san-pham/get-km-lsp"
            case .getLoaiSanPhamGood:
                path = "/loai-san-pham/get-good-lsp"
            case .getLoaiSanPhamHang:
                path = "/loai-san-pham/get-good-lsp-hang"
                
            case .searchLSP:
                path = "/loai-san-pham/search"
                
            case .getGioHang: path = "/gio-hang/gio-hang-byKH"
            case .addGioHang: path = "/gio-hang"
            case .updateGioHang: path = "/gio-hang"
            case .deleteGioHang: path = "/gio-hang"
                
            case .addUser: path = "/khach-hang"
            case .updateUser: path = "/khach-hang"
            
            case .getHistoryOrder: path = "/gio-hang/history-order"
            case .delTK: path = "/tai-khoan"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
            case  .getHangSX, .getLoaiSanPhamFull, .getLoaiSanPhamNew,
                    .getGioHang, .getLoaiSanPhamKM, .getLoaiSanPhamGood, .getLoaiSanPhamHang, .searchLSP,
                    .getHistoryOrder
                :
                return .get
            case .login, .register, .resetPass, .addGioHang, .addUser:
                return .post
            case .updateGioHang, .updateUser:
                return .put
            case .deleteGioHang, .delTK:
                return .delete
                
        }
    }
    
    //MARK: - HEADER
    var header: HTTPHeader? {
        switch self {
            default:
                return nil
        }
    }
    
    //MARK: - ENCODING
    
    var encoding: ParameterEncoding {
        switch self.method {
            case .post, .put:
                return JSONEncoding.default
            case .get:
                return URLEncoding.default
            default:
                return URLEncoding.default
        }
    }
}
struct Header {
    static let authorization            = "Authorization"
    static let contentType              = "Content-Type"
    static let contentTypeValue         = "application/json"
}

