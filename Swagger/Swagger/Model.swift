//
//  Model.swift
//  Swagger
//
//  Created by MAC13 on 13.04.2023.
//

import Foundation

struct MyResponse: Codable {
    let content: [Content]
    let page: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
}

struct Content: Codable {
    let id: Int
    let name: String
    let image: String
}


let item: [MyResponse] = []
