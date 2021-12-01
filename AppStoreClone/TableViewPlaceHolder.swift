//
//  TableViewPlaceHolder.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/12/01.
//

import UIKit

class TableViewPlaceHolder: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
