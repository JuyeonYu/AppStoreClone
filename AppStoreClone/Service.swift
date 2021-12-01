//
//  Service.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation
import RxSwift

class Service {
    static let shared = Service()
    func fetchApps(term: String) -> Observable<SearchResultResponse?> {
        return Observable.create { observer in
            let formattedTerm = term.replacingOccurrences(of: " ", with: "+")
            guard let encodedTerm = formattedTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return Disposables.create()
            }
            let locale = Locale.current.regionCode?.lowercased() ?? "kr"
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&entity=software&country=\(locale)") else {
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                if let err = err {
                    observer.onError(err)
                    return
                }
                guard let data = data else { return }
                do {
                    let objects = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    observer.onNext(objects)
                } catch let err {
                    observer.onError(err)
                }
            }.resume()
            return Disposables.create()
        }
    }
}
