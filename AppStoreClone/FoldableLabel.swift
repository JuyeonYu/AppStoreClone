//
//  FoldableLabel.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/11/30.
//

import UIKit


class FoldableLabel: UIView {
    let initialLabelNumber = 2
    var onToggle: (() -> Void)?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var toggle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.numberOfLines = initialLabelNumber
        label.lineBreakMode = .byWordWrapping
    }
    static func loadViewFromNib() -> FoldableLabel {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "FoldableLabel", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first {
            ($0 as? UIView)?.restorationIdentifier == "FoldableLabel"
        }! as! FoldableLabel
    }
    @IBAction func onToggle(_ sender: Any) {
        onToggle?()
    }
}

class FoldableLabelStoryView: UIView {
    var contentView: FoldableLabel
    required init?(coder aDecoder: NSCoder) {
        contentView = FoldableLabel.fromNib()
        super.init(coder: aDecoder)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
