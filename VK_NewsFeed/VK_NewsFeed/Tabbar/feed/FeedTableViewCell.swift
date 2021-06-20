//
//  FeedTableViewCell.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var coments: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var views: UILabel!
}

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
           // Determine the scale factor that preserves aspect ratio
           let widthRatio = targetSize.width / size.width
           let heightRatio = targetSize.height / size.height
           
           let scaleFactor = min(widthRatio, heightRatio)
           
           // Compute the new image size that preserves aspect ratio
           let scaledImageSize = CGSize(
               width: size.width * scaleFactor,
               height: size.height * scaleFactor
           )

           // Draw and return the resized UIImage
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

extension UIViewController {
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait for loading data...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
}
