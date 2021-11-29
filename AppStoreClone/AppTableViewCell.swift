//
//  AppTableViewCell.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    let maxScreenShotCount: Int = 3
    fileprivate func addScreenShots(_ app: AppStoreApp) {
        for i in 0 ..< maxScreenShotCount {
            let imageView = screenshots.subviews[i] as? UIImageView
            if let urlString = app.screenshotUrls[safe: i] {
                if let screenshot = ImageCacheManager.shared.image(from: urlString) {
                    imageView?.image = screenshot
                } else {
                    ImageCacheManager.shared.save(key: app.screenshotUrls[safe: i] ?? "")
                    imageView?.load(urlString: urlString)
                }
            } else {
                screenshots.subviews[i].removeFromSuperview()
            }
        }
    }
    
    var app: AppStoreApp? {
        didSet {
            guard let app = app else { return }
            appName.text = app.trackName
            genre.text = app.primaryGenreName
            ratingCount.text = "\(app.userRatingCount)"
            addStar(rating: app.averageUserRating)
            if let logo = ImageCacheManager.shared.image(from: app.artworkUrl60) {
                thumbnail.image = logo
            } else {
                ImageCacheManager.shared.save(key: app.artworkUrl60)
                thumbnail.load(urlString: app.artworkUrl60)
            }
            addScreenShots(app)
        }
    }
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var stars: UIStackView!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var screenshots: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = thumbnail.frame.width / 10
        thumbnail.layer.borderColor = UIColor.gray.cgColor
        thumbnail.layer.borderWidth = 0.5
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        if screenshots.subviews.count < maxScreenShotCount {
            addScreenShotImageView()
        }
        screenshots.subviews.forEach {
            let screenshot = $0 as? UIImageView
            screenshot?.image = nil
        }
    }
    fileprivate func addScreenShotImageView() {
        guard screenshots.subviews.count < maxScreenShotCount else {
            return
        }
        screenshots.addArrangedSubview(UIImageView())
        addScreenShotImageView()
    }
    fileprivate func addStar(rating: Double) {
        let digit: Double = pow(10, 1)
        var rating = round(rating * digit) / digit
        for i in 0 ..< 5 {
            let imageView = stars.subviews[i] as? UIImageView
            
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
