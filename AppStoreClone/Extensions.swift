//
//  Extensions.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}

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

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension UITableView {
    func setEmptyMessage(title: String, subTitle: String) {
        let tableViewPlaceHolder = Bundle.main.loadNibNamed("TableViewPlaceHolder", owner: nil, options: nil)?.first as? TableViewPlaceHolder
        tableViewPlaceHolder?.title.text = title
        tableViewPlaceHolder?.subTitle.text = subTitle
        self.separatorStyle = .none
        self.backgroundView = tableViewPlaceHolder
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
