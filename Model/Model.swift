//
//  Model.swift
//  ImageApp
//
//  Created by Teppei Sasaki on 2022/06/16.
//

import Foundation

// Data → byte
struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
