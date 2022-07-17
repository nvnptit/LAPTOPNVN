//
//  JSONDecoder.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from data: Data?, completion: @escaping(_ error: String?, _ result: T?) -> Void) {
        
        guard let data = data else {
            completion("The data coundn't be read because it is missing",nil)
            return
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let result = try jsonDecoder.decode(type, from: data)
            completion(nil,result)
        } catch(let error) {
            completion(error.localizedDescription,nil)
        }
    }
}
 
