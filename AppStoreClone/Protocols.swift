//
//  Protocols.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/12/01.
//

import Foundation
import UIKit

protocol ConfigurableView {
    associatedtype DataType
    func configure(data: DataType)
}

protocol ViewConfigurator {
    static var reusableId: String { get }
    func configure(view: UIView)
}
