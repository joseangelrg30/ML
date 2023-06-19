//
//  SearchResultTableViewCell.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet private var productId: UILabel!
    @IBOutlet private var productDescription: UILabel!
    @IBOutlet private var productPrice: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    private var viewModel: SearchResultCellViewModel!
    private var bindings = Bindings()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - CellViewModelConfigurable
extension SearchResultTableViewCell: CellViewModelConfigurable {
    func configure(cellViewModel: CellViewModel) {
        guard let cellViewModel = cellViewModel as? SearchResultCellViewModel else {
            return
        }
        
        viewModel = cellViewModel
        
        bindings.removeAll()
        
        viewModel.$productId
            .assign(to: \.text, on: productId)
            .store(in: &bindings)
        
        viewModel.$productDescription
            .assign(to: \.text, on: productDescription)
            .store(in: &bindings)

        viewModel.$productPrice
            .assign(to: \.text, on: productPrice)
            .store(in: &bindings)

        viewModel.$thumbnailImage
            .assign(to: \.image, on: thumbnailImageView)
            .store(in: &bindings)

    }
    
    func configureWillDisplayCell(cellViewModel: CellViewModel) {
        viewModel.loadThumbnailImage()
    }
}
