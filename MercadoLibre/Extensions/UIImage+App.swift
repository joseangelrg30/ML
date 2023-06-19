//
//  UIImage+App.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

extension UIImage {
    private static let imageCache = NSCache<NSString, UIImage>()

    static func loadImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is available in the cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        // If not in cache, download the image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                completion(nil)
                return
            }

            // Cache the downloaded image
            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        task.resume()
    }
}
