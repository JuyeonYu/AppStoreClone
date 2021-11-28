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
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(term)&entity=software") else { return  }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            do {
                let objects = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                completion(objects, nil)
            } catch let jsonErr {
                completion(nil, err)
            }
        }.resume()
    }
}
