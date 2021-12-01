//
//  SearchReactor.swift
//  AppStoreClone
//
//  Created by Medistaff on 2021/12/01.
//

import Foundation
import ReactorKit

enum SearchViewContentType {
    case keyword
    case app
}

class SearchReactor: Reactor {
    enum Action {
        case read(keyword: String)
        case onSearch(keyword: String)
    }
    enum Mutation {
        case setMySearches([MySearch])
        case setApps([AppStoreApp]?, keyword: String)
    }
    struct State {
        var contentType: SearchViewContentType = .keyword
        var apps: [AppStoreApp] = []
        var mySearches: [MySearch] = []
        var keyword: String = ""
    }
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .read(keyword: let keyword):
            return .just(.setMySearches(RealmManager.shared.fetchMySearches(keyword: keyword)))
        case .onSearch(keyword: let keyword):
            RealmManager.shared.writeMySearch(keyword: keyword)
            return .concat([
                Service.shared.fetchApps(term: keyword).map { .setApps($0?.results, keyword: keyword) }
            ])
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMySearches(let mySearches):
            newState.mySearches = mySearches.sorted(by: {$0.id > $1.id})
            newState.contentType = .keyword
        case let .setApps(apps, keyword: keyword):
            newState.contentType = .app
            newState.apps = apps ?? []
            newState.keyword = keyword
        }
        return newState
    }
}
