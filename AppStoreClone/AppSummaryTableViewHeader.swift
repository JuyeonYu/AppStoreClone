//
//  AppSummaryTableViewHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/29.
//

import UIKit

class AppSummaryTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var chartStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var developerStackView: UIStackView!
    @IBOutlet weak var languageStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
