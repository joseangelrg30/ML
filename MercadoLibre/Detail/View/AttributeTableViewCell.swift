//
//  AttributeTableViewCell.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

class AttributeTableViewCell: UITableViewCell {
    @IBOutlet private var attributeName: UILabel!
    @IBOutlet private var attributeValue: UILabel!

    private var viewModel: AttributeCellViewModel!
    private var bindings = Bindings()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - CellViewModelConfigurable
extension AttributeTableViewCell: CellViewModelConfigurable {
    func configure(cellViewModel: CellViewModel) {
        guard let cellViewModel = cellViewModel as? AttributeCellViewModel else {
            return
        }
        
        viewModel = cellViewModel
        
        bindings.removeAll()
        
        viewModel.$attributeName
            .assign(to: \.text, on: attributeName)
            .store(in: &bindings)
        
        viewModel.$attributeValue
            .assign(to: \.text, on: attributeValue)
            .store(in: &bindings)

    }
}
