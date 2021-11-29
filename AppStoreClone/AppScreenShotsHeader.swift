//
//  AppScreenShotsHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/30.
//

import UIKit

class AppScreenShotsHeader: UITableViewHeaderFooterView {    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ScreenshotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScreenshotCollectionViewCell")
    }

}
