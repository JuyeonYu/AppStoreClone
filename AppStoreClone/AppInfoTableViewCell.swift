//
//  AppInfoTableViewCell.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/30.
//

import UIKit

class AppInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var infoView: MenuTitleViewStoryView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
