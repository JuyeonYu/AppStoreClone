//
//  RealmManager.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private var realm = try! Realm()
    func fetchMySearches(keyword: String) -> [MySearch] {
        if keyword.isEmpty {
            return realm.objects(MySearch.self).toArray(ofType: MySearch.self)
        } else {
            return realm.objects(MySearch.self).filter("keyword CONTAINS %@", keyword).toArray(ofType: MySearch.self)
        }
        
    }
    func writeMySearch(keyword: String) {
        if let duplicate = realm.objects(MySearch.self).filter("keyword = %@", keyword).first {
            try! realm.write {
                duplicate.id = Int(Date().timeIntervalSince1970 * 1000)
            }
        } else {
            try! realm.write {
                realm.add(MySearch(keyword: keyword))
            }
        }
    }
}
