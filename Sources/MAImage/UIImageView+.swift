//
//  File.swift
//  
//
//  Created by Murilo Araujo on 10/10/20.
//

import Foundation
import UIKit

extension UIImageView {
    public func loadImage(with urlString: String, and placeholderImage: UIImage = UIImage()) {
        self.image = placeholderImage
        
        MAImage.shared.getImageBy(urlString: urlString) { (image) in
            if let image = image {
                self.image = image
            }
        }
    }
}

