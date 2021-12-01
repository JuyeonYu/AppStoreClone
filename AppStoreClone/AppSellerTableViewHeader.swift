//
//  AppSellerTableViewHeader.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/30.
//

import UIKit

class AppSellerTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var seller: UILabel!
    var app: AppStoreApp! {
        didSet {
            seller.text = app.sellerName
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
