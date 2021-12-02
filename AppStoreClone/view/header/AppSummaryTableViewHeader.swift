//
//  AppSummaryTableViewHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/29.
//

import UIKit

class AppSummaryTableViewHeader: UITableViewHeaderFooterView {
    var app: AppStoreApp! {
        didSet {
            (ratingStackView.subviews[0] as? UILabel)?.text = "\(app.userRatingCount)개의 평가"
            (ratingStackView.subviews[1] as? UILabel)?.text = "\((round(app.averageUserRating * 10) / 10))"
            (ratingStackView.subviews[2] as? UIStackView)?.addStar(rating: app.averageUserRating)
            (ageStackView.subviews[1] as? UILabel)?.text = app.trackContentRating
            (categoryStackView.subviews[2] as? UILabel)?.text = app.genres.first
            (languageStackView.subviews[1] as? UILabel)?.text = app.languageCodesISO2A.contains(Locale.current.regionCode ?? "KO") ? Locale.current.regionCode : app.languageCodesISO2A.first
            (languageStackView.subviews[2] as? UILabel)?.text = "+ \(app.languageCodesISO2A.count)개 언어"
            (developerStackView.subviews[2] as? UILabel)?.text = app.sellerName
        }
    }
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var developerStackView: UIStackView!
    @IBOutlet weak var languageStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
