//
//  ViewConfigurator.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/12/01.
//

import Foundation
import UIKit

class TableHeaderViewConfigurator<ViewType: ConfigurableView, DataType>: ViewConfigurator where ViewType.DataType == DataType, ViewType: UIView {
    static var reusableId: String { return String(describing: ViewType.self) }
    let item: DataType
    init(item: DataType) {
        self.item = item
    }
    func configure(view: UIView) {
        (view as! ViewType).configure(data: item)
    }
}
