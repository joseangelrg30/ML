//
//  MLSearchResults.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

struct MLSearchResults: Decodable {
    let query: String    
    let results: [Product]
    let paging: Paging
    
    struct Product: Decodable {
        let id: String
        let title: String
        let condition: String
        let price: Float
        let thumbnail: String
    }
    
    struct Paging: Decodable {
        let total: Int
        let limit: Int
        let offset: Int
        let primary_results: Int
    }

}
