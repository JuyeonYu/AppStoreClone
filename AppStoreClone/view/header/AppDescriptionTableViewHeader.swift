//
//  AppDescriptionTableViewHeader.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/30.
//

import UIKit

class AppDescriptionTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var foldableLabel: FoldableLabelStoryView!
    var app: AppStoreApp! {
        didSet {
            foldableLabel.contentView.label.text = app.description
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(isUnfoldDescription: Bool) {
        let initialLabelNumber = foldableLabel.contentView.initialLabelNumber
        foldableLabel.contentView.label.numberOfLines = isUnfoldDescription ? 0 : initialLabelNumber
        foldableLabel.contentView.toggle.isHidden = isUnfoldDescription || foldableLabel.contentView.label.calculateMaxLines() == initialLabelNumber
    }
}
