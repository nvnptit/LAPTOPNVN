//
//  String.swift
//  LAPTOPNVN
//
//  Created by Nhat on 26/07/2022.
//

import UIKit
import Foundation
//OLD
import CommonCrypto

//new:
import CryptoKit

extension String {
    var md5: String {
        
        if #available(iOS 13.0, *) {
            
            guard let d = self.data(using: .utf8) else { return ""}
            let digest = Insecure.MD5.hash(data: d)
            let h = digest.reduce("") { (res: String, element) in
                let hex = String(format: "%02x", element)
                //print(ch, hex)
                let  t = res + hex
                return t
            }
            return h
            
        } else {
            // Fall back to pre iOS13
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            
            if let d = self.data(using: .utf8) {
                _ = d.withUnsafeBytes { body -> String in
                    CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                    return ""
                }
            }
            let result = (0 ..< length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
            return result
            
        }// end of fall back
        
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

extension UILabel {
    
    func strikeThrough(_ isStrikeThrough:Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}
extension String {
    
    func unaccent() -> String {
        
        return self.folding(options: .diacriticInsensitive, locale: .current)
        
    }
    func replaceCharacters(characters: String, toSeparator: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = components(separatedBy: characterSet)
        let result = components.joined(separator: toSeparator)
        return result
    }

    func wipeCharacters(characters: String) -> String {
        return self.replaceCharacters(characters: characters, toSeparator: "")
    }
}
