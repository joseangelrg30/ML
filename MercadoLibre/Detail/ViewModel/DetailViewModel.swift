//
//  DetailViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func viewModelShouldDisplayError(_ viewModel: DetailViewModel, error: MLErrors)
}

protocol DetailViewModelDisplayDelegate: AnyObject {
    func viewModelDidRequestReload(_ viewModel: DetailViewModel)
}

class DetailViewModel: NSObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var productTitle: String?
    @Published private(set) var price: String?

    @Published private(set) var thumbnailImage: UIImage?
    @Published private(set) var isLoadingImage: Bool = false

    weak var delegate: DetailViewModelDelegate?
    weak var displayDelegate: DetailViewModelDisplayDelegate?

    private var product: MLSearchResults.Product
    private var picturesCellViewModels = [PictureCellViewModel]()
    private var attributesCellViewModels = [AttributeCellViewModel]()

    init(product: MLSearchResults.Product) {
        self.product = product
        self.productTitle = self.product.title.trimmingCharacters(in: .whitespaces)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let number = NSNumber(value: product.price)
        
        if let formattedString = formatter.string(from: number) {
            price = formattedString
        }

        super.init()
    }
    
    func loadProduct() {
        isLoading = true
        let webService = WebService(urlString: "https://api.mercadolibre.com/items")
        webService.getProduct(with: product.id) { [weak self] (itemReturned, error) in
            guard let self = self else { return }
         
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.delegate?.viewModelShouldDisplayError(self, error: error)
                }
            } else {
                
                let pictureCellModels = itemReturned?.first?.body.pictures.map {
                    let searchModel = PictureCellViewModel(picture: $0)
                    return searchModel
                }
                
                let attributesCellModels = itemReturned?.first?.body.attributes.map {
                    let attributeModel = AttributeCellViewModel(attribute: $0)
                    return attributeModel
                }
                
                //print(itemReturned)
                
                DispatchQueue.main.async {
                    self.picturesCellViewModels = pictureCellModels ?? [PictureCellViewModel]()
                    self.attributesCellViewModels = attributesCellModels ?? [AttributeCellViewModel]()
                    self.displayDelegate?.viewModelDidRequestReload(self)
                    self.isLoading = false
                }
                
                loadProductImage()
            }
        }
    }
    
    func loadProductImage() {
        guard !isLoadingImage else {
            return
        }
        
        isLoadingImage = true
        let imageURL = product.thumbnail
        UIImage.loadImageFromURL(imageURL) { image in
            DispatchQueue.main.async {
                self.thumbnailImage = image
            }
            self.isLoadingImage = false
        }
    }
}


extension DetailViewModel {
    func handleViewDidLoad() {
        loadProduct()
    }
}

// MARK: - Public Methods
extension DetailViewModel {
    var totalPictures: Int {
        return picturesCellViewModels.count
    }
    
    var totalAttributes: Int {
        return attributesCellViewModels.count
    }

    func cellViewModel(at indexPath: IndexPath) -> PictureCellViewModel? {
        guard picturesCellViewModels.indices.contains(indexPath.row) else {
            return nil
        }
        return picturesCellViewModels[indexPath.row]
    }
    
    func attributeCellViewModel(at indexPath: IndexPath) -> AttributeCellViewModel? {
        guard attributesCellViewModels.indices.contains(indexPath.row) else {
            return nil
        }
        return attributesCellViewModels[indexPath.row]
    }
}
