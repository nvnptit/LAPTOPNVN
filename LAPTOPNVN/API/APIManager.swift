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
    case getLoaiSanPhamFull
    case getHangSX
    case getLoaiSanPhamNew
    case addSanPham
}

extension APIManager {
    var baseURL: String  { return "http://192.168.1.74/api"}
    
    //MARK: - URL
    var url: String {
        var path = ""
        //        let version = "/v1"
        
        switch self {
            case .login: path = "/login"
            case .getLoaiSanPhamFull:
                path = "/loai-san-pham"
            case .getHangSX:
                path = "/hang-sx"
            case .getLoaiSanPhamNew:
                path = "/loai-san-pham/get-new-lsp"
            case .addSanPham:
                path = "/add"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
            case .getLoaiSanPhamFull, .getHangSX, .getLoaiSanPhamNew:
                return .get
            case .login, .addSanPham:
                return .post
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
        case .post:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
struct Header {
    static let authorization            = "Authorization"
    static let contentType              = "Content-Type"
    static let contentTypeValue         = "application/json"
}

