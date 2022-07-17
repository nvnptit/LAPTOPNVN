//
//  Encodable.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

extension Encodable {
    func convertToDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dataEncodingStrategy = .base64
        do {
          let jsonData = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let dictionary = json as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch {
            print("Error encode")
            return [:]
        }
    }
}
