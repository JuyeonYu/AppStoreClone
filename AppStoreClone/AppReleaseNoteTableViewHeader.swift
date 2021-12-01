//
//  AppReleaseNoteTableViewHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/30.
//

import UIKit

class AppReleaseNoteTableViewHeader: UITableViewHeaderFooterView {
    var app: AppStoreApp! {
        didSet {
            foldableLabel.contentView.label.text = app.releaseNotes
            version.text = app.version
            date.text = app.currentVersionReleaseDate.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")?.pastFromNow()
        }
    }
    func configure(isUnfoldReleaseNote: Bool) {
        let initialLabelNumber = foldableLabel.contentView.initialLabelNumber
        foldableLabel.contentView.label.numberOfLines = isUnfoldReleaseNote ? 0 : initialLabelNumber
        foldableLabel.contentView.toggle.isHidden = isUnfoldReleaseNote ||
                                                    foldableLabel.contentView.label.calculateMaxLines() == initialLabelNumber
    }
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var foldableLabel: FoldableLabelStoryView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
