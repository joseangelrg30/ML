//
//  ImageCollectionViewCell.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    private var viewModel: PictureCellViewModel!
    private var bindings = Bindings()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - CellViewModelConfigurable
extension ImageCollectionViewCell: CellViewModelConfigurable {
    func configure(cellViewModel: CellViewModel) {
        guard let cellViewModel = cellViewModel as? PictureCellViewModel else {
            return
        }
        
        viewModel = cellViewModel
        
        bindings.removeAll()
        
        viewModel.$image
            .assign(to: \.image, on: imageView)
            .store(in: &bindings)
    }
    
    func configureWillDisplayCell(cellViewModel: CellViewModel) {
        viewModel.loadImage()
    }
}
