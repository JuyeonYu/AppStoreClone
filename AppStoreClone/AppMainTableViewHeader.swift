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
    override func awakeFromNib() {
        super.awakeFromNib()
        download.backgroundColor = .tintColor
        download.setTitleColor(.white, for: .normal)
        download.layer.cornerRadius = 10
        download.layer.masksToBounds = true
    }
}
