//
//  Extensions.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 20.06.21.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func load(urlString: String, targetSize: CGSize) {
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image.scalePreservingAspectRatio(targetSize: targetSize)
                    }
                }
            }
        }
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
           let widthRatio = targetSize.width / size.width
           let heightRatio = targetSize.height / size.height
           
           let scaleFactor = min(widthRatio, heightRatio)
           
           let scaledImageSize = CGSize(
               width: size.width * scaleFactor,
               height: size.height * scaleFactor
           )

           let renderer = UIGraphicsImageRenderer(
               size: scaledImageSize
           )

           let scaledImage = renderer.image { _ in
               self.draw(in: CGRect(
                   origin: .zero,
                   size: scaledImageSize
               ))
           }
           
           return scaledImage
       }
}
