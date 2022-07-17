//
//  APIResponse.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

struct ResponseBase<T: Decodable>: Decodable {
    var success: Bool?
    var data: T?
}
