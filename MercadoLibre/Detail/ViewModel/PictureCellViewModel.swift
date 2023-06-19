//
//  PictureCellViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

class PictureCellViewModel: NSObject {
    @Published private(set) var imageURL: String?    
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoadingImage: Bool = false
    @Published private(set) var isImageLoaded: Bool = false

    private var picture: MLItem.Picture

    init(picture: MLItem.Picture) {
        self.picture = picture
        self.imageURL = picture.secure_url
        super.init()
    }
    
    func loadImage() {
        guard let url = imageURL, !isLoadingImage, !isImageLoaded else {
            return
        }
        
        isLoadingImage = true
        UIImage.loadImageFromURL(url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
            self.isLoadingImage = false
            self.isImageLoaded = true
        }
    }
}

// MARK: - CellViewModel
extension PictureCellViewModel: CellViewModel {
    static let cellIdentifier = "PictureCell"

    var cellIdentifier: String {
        return Self.cellIdentifier
    }
}
