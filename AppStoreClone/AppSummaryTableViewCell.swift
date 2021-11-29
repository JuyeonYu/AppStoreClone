//
//  AppSummaryTableViewCell.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/29.
//

import UIKit

class AppSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var appSummaryViewController: AppSummaryViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
    }
}

extension AppSummaryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
}
