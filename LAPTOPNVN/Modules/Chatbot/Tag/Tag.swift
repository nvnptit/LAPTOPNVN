//
//  Tag.swift
//  LAPTOPNVN
//
//  Created by Nhat on 07/11/2022.
//

import Foundation


// MARK: - Tag
struct Tag {
    let data: [Intent]?
}

// MARK: - Intent
struct Intent {
    let tag: String?
    let patterns: [String]?
    let responses: Int?
}
