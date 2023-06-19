//
//  MLItem.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

struct MLItem: Decodable {
    let body: Body
    
    struct Body: Decodable {
        let id: String
        let title: String
        let condition: String
        let price: Float
        let thumbnail: String
        let pictures: [Picture]
        let attributes: [Attribute]
    }
    
    struct Picture: Decodable {
        let id: String
        let secure_url: String
        let size: String
    }
    
    struct Attribute: Decodable {
        let id: String
        let name: String
        let value_name: String?
    }

}
