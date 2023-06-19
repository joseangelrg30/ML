//
//  SearchResultCellViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation
import Combine
import UIKit

protocol SearchResultCellViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: SearchResultCellViewModel, didSelect product: MLSearchResults.Product)
}

class SearchResultCellViewModel: NSObject {
    @Published private(set) var productId: String?
    @Published private(set) var productDescription: String?
    @Published private(set) var productPrice: String?
    @Published private(set) var productThumbnail: String?

    @Published private(set) var thumbnailImage: UIImage?
    @Published private(set) var isLoadingImage: Bool = false
    
    private let product: MLSearchResults.Product
    weak var delegate: SearchResultCellViewModelDelegate?

    init(product: MLSearchResults.Product) {
        self.product = product
        productId = product.id
        productDescription = product.title.trimmingCharacters(in: .whitespaces)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let number = NSNumber(value: product.price)
        
        if let formattedString = formatter.string(from: number) {
            productPrice = formattedString
        }
        
        productThumbnail = product.thumbnail
        super.init()
    }
    
    func loadThumbnailImage() {
        guard let imageURL = productThumbnail, !isLoadingImage else {
            return
        }
        
        isLoadingImage = true
        UIImage.loadImageFromURL(imageURL) { image in
            DispatchQueue.main.async {
                self.thumbnailImage = image
            }
            self.isLoadingImage = false
        }
    }
}

// MARK: - CellViewModel
extension SearchResultCellViewModel: CellViewModel {
    static let cellIdentifier = "SearchResultCell"

    var cellIdentifier: String {
        return Self.cellIdentifier
    }
}

// MARK: - Handlers
extension SearchResultCellViewModel {
    func handleSelection() {
        delegate?.viewModel(self, didSelect: product)
    }
}
