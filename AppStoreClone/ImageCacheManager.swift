//
//  ImageCacheManager.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    func save(key: String?) {
        guard let url = URL(string: key ?? "") else { return }
        if imageCache.object(forKey: url.absoluteString as NSString) == nil {
            DispatchQueue.global().async { [weak self] in
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            }
        }
    }
    func image(from key: String) -> UIImage? {
        guard let url = URL(string: key) else { return nil }
        return imageCache.object(forKey: url.absoluteString as NSString)
    }
}
