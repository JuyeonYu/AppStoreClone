//
//  ScreenshotCollectionViewCell.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/30.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var screenshot: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        screenshot.layer.borderWidth = 0.5
        screenshot.layer.borderColor = UIColor.systemGray.cgColor
        screenshot.layer.cornerRadius = 10
        screenshot.layer.masksToBounds = true
    }
}
