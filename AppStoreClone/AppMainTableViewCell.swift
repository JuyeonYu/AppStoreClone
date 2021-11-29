//
//  AppMainTableViewCell.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/29.
//

import UIKit

class AppMainTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var download: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        download.layer.cornerRadius = download.frame.width / 4
        download.layer.masksToBounds = true
        download.backgroundColor = .blue
    }
}
