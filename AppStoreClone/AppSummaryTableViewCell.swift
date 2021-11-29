//
//  AppSummaryTableViewCell.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/29.
//

import UIKit

class AppSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
