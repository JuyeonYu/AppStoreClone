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
//    private func getRealm() -> Realm {
//        return try! Realm()
//    }
    private var realm = try! Realm()
    func readMySearches() -> [MySearch] {
//        let realm = getRealm()
        realm.objects(MySearch.self).toArray(ofType: MySearch.self)
    }
    func fetchMySearches(keyword: String) -> [MySearch] {
        realm.objects(MySearch.self).filter("keyword CONTAINS %@", keyword).toArray(ofType: MySearch.self)
    }
    func writeMySearch(keyword: String) {
//        let realm = getRealm()
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

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
