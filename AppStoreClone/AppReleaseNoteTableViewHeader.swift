//
//  AppReleaseNoteTableViewHeader.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/30.
//

import UIKit

class AppReleaseNoteTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var foldableLabel: FoldableLabelStoryView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
