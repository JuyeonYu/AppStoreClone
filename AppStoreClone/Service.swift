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
    
    func fetchApps(term: String, completion: @escaping (SearchResultResponse?, Error?) -> ()) {
        let formattedTerm = term.replacingOccurrences(of: " ", with: "+")
        guard let encodedTerm = formattedTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let locale = Locale.current.regionCode?.lowercased() ?? "kr"
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&entity=software&country=\(locale)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            guard let data = data else { return }
            do {
                let objects = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                completion(objects, nil)
            } catch _ {
                completion(nil, err)
            }
        }.resume()
    }
}
