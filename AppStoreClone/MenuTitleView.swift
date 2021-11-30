//
//  MenuTitleView.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/30.
//

import UIKit

class MenuTitleView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var accessory: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class MenuTitleViewStoryView: UIView {
    var contentView: MenuTitleView
    required init?(coder aDecoder: NSCoder) {
        contentView = MenuTitleView.fromNib()
        super.init(coder: aDecoder)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
