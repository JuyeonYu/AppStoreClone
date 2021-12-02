//
//  MySearch.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import RealmSwift

class MySearch: Object {
    @objc dynamic var id: Int = Int(Date().timeIntervalSince1970 * 1000)
    @objc dynamic var keyword: String = ""
    
    convenience init(keyword: String) {
        self.init()
        self.id = Int(Date().timeIntervalSince1970 * 1000)
        self.keyword = keyword
    }
}
