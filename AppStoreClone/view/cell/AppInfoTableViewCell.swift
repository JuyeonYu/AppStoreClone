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
    }
    
    func configure(appInfo: [[String]], row: Int) {
        infoView.contentView.title.text = appInfo[row][0]
        infoView.contentView.subTitle.text = appInfo[row][1]
        infoView.contentView.subTitle.isHidden = row == appInfo.count - 1
        infoView.contentView.accessory.isHidden = row < appInfo.count - 1
        infoView.contentView.title.textColor = row < appInfo.count - 1 ? .systemGray : .tintColor
    }
}
