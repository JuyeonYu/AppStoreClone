//
//  TableViewData.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/12/01.
//

import Foundation
import RxDataSources

enum SearchModel {
    case Keywords(items: [SearchItem])
    case Apps(items: [SearchItem])
}

enum SearchItem {
    case Keyword(MySearch)
    case App(AppStoreApp)
}

extension SearchModel: SectionModelType {
    typealias Item = SearchItem
    
    var items: [SearchItem] {
        switch self {
        case .Keywords(items: let items): return items.map { $0 }
        case .Apps(items: let items): return items.map { $0 }
        
        }
    }
    
    init(original: SearchModel, items: [Item]) {
        switch original {
        case .Keywords(items: let items): self = .Keywords(items: items)
        case .Apps(items: let items): self = .Apps(items: items)
        }
    }
}
