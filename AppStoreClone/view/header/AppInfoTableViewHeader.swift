//
//  AppInfoTableViewHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/12/01.
//

import UIKit

class AppInfoTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var infoView: MenuTitleViewStoryView!
    override func awakeFromNib() {
        super.awakeFromNib()
        infoView.contentView.title.text = "정보"
        infoView.contentView.title.font = UIFont.boldSystemFont(ofSize: 20)
        infoView.contentView.subTitle.isHidden = true
        infoView.contentView.accessory.isHidden = true
    }
    
}
