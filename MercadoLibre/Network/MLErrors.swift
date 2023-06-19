//
//  MLErrors.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

enum MLErrors: Error {
    case responseModelParsingError
    case invalidRequestURLStringError
    case couldNotConnectToServer
}
