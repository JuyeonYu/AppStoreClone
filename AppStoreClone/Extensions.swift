//
//  Extensions.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension UIImageView {
    func load(urlString: String?) {
        guard let urlString = urlString else {
            self.image = nil
            return
        }
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        if let image = ImageCacheManager.shared.image(from: urlString) {
            self.image = image
        } else {
            ImageCacheManager.shared.save(key: urlString)
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIStackView {
    func addStar(rating: Double) {
        let digit: Double = pow(10, 1)
        var rating = round(rating * digit) / digit
        for i in 0 ..< 5 {
            let imageView = self.subviews[i] as? UIImageView
            
            if rating > 1 {
                imageView?.image = UIImage(systemName: "star.fill")
            } else if rating >= 0.5 {
                imageView?.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView?.image = UIImage(systemName: "star")
            }
            rating -= 1
        }
    }
}
