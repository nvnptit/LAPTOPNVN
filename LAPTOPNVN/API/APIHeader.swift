//
//  APIHeader.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

class APIHeader {
    
    static func headers() -> HTTPHeaders? {
        return [.contentType("application/json") ]
    }
    
//    static func getAuthHeader() -> HTTPHeaders? {
//        guard let token = UserService.shared.getTokenLogin() else { return nil }
//        return [.authorization(token)]
//    }
//
    static func multipartFormData() -> HTTPHeaders? {
        return [.contentType("multipart/form-data") ]
    }
}
