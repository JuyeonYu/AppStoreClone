//
//  AppMainHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/29.
//

import UIKit

class AppMainTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    var app: AppStoreApp! {
        didSet {
            thumbnail.load(urlString: app.artworkUrl100)
            title.text = app.trackName
            genre.text = app.genres.first
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 20
        thumbnail.layer.masksToBounds = true
        download.backgroundColor = .tintColor
        download.setTitleColor(.white, for: .normal)
        download.layer.cornerRadius = 10
        download.layer.masksToBounds = true
    }
}
