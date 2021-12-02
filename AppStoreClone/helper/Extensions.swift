//
//  Extensions.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import UIKit
import RealmSwift

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
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {        
        let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: type))
        guard let viewType = view as? T else {
            fatalError("Dequeue failed, expect: \(type) was: \(String(describing: view))")
        }
        return viewType
    }
    func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath)
        guard let cellType = cell as? T else {
            fatalError("Dequeue failed, expect: \(type) was: \(cell)")
        }
        return cellType
    }
    func registerCellFromNib<T: UITableViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    func registerViewFromNib<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
}

extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath)
        guard let cellType = cell as? T else {
            fatalError("Dequeue failed, expect: \(type) was: \(cell)")
        }
        return cellType
    }
    func registerCellFromNib<T: UICollectionViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellWithReuseIdentifier: String(describing: type))
    }
}

extension String {
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.date(from: self)
    }
}

extension Date {
    func pastFromNow() -> String {
        let timeInterval = round(self.timeIntervalSinceNow.magnitude)
        let year = round(timeInterval / 60 / 60 / 24 / 30 / 12)
        guard year < 1 else {
            return "\(Int(year))년 전"
        }
        let month = round(timeInterval / 60 / 60 / 24 / 30)
        guard month < 1 else {
            return "\(Int(month))달 전"
        }
        let day = round(timeInterval / 60 / 60 / 24)
        guard day < 1 else {
            return "\(Int(day))일 전"
        }
        let hour = round(timeInterval / 60 / 60)
        guard hour < 1 else {
            return "\(Int(hour))시간 전"
        }
        let minute = round(timeInterval / 60)
        guard minute < 1 else {
            return "\(Int(minute))분 전"
        }
        return "최근"
    }
}

extension Int {
    func shorten() -> String {
        guard self > 999 else {
            return "\(self)"
        }
        guard self > 9999 else {
            return "\(round(Double(self) / 1000.0 * 10) / 10)천"
        }
        guard self > 99999999 else {
            return "\(round(Double(self) / 10000.0 * 10) / 10)만"
        }
        return "\(self)"
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
