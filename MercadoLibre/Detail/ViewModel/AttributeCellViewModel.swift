//
//  AttributeCellViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

class AttributeCellViewModel: NSObject {
    @Published private(set) var attributeName: String?
    @Published private(set) var attributeValue: String?

    private var attribute: MLItem.Attribute

    init(attribute: MLItem.Attribute) {
        self.attribute = attribute
        self.attributeName = self.attribute.name
        self.attributeValue = self.attribute.value_name
        super.init()
    }
}

// MARK: - CellViewModel
extension AttributeCellViewModel: CellViewModel {
    static let cellIdentifier = "AttributeCell"

    var cellIdentifier: String {
        return Self.cellIdentifier
    }
}
