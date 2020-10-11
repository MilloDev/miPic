
import Disk
import Foundation
import UIKit

@objc
public class MAImage: NSObject {
    
    @objc public static let shared = MAImage()
    
    @objc public func getImageBy(urlString: String, completion: @escaping (UIImage?)->Void) {
        if let persistedImage = getImage(by: urlString) {
            completion(persistedImage)
        } else {
            downloadImage(from: urlString) { (image) in
                guard let imageLiteral = image else {
                    completion(nil)
                    return
                }
                self.persist(image: imageLiteral, with: urlString)
                DispatchQueue.main.async {
                    completion(imageLiteral)
                }
                
            }
        }
    }
    
    private func persist(image: UIImage, with urlString: String) {
        try? Disk.save(image, to: .caches, as: path(url: urlString))
    }
    
    private func getImage(by urlString: String) -> UIImage? {
        let image = try? Disk.retrieve(path(url: urlString), from: .caches, as: UIImage.self)
        return image
    }
    
    private func path(url: String) -> String {
        return "Images/\(url)"
    }
    
    private func downloadImage(from urlstring: String, completion: @escaping (UIImage?)->Void) {
        guard let imageURL = URL(string: urlstring) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
