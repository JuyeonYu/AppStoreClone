//
//  SearchResult.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import Foundation

struct SearchResultResponse: Codable {
    let resultCount: Int
    let results: [AppStoreApp]
}

struct AppStoreApp: Codable {
    let screenshotUrls: [String]
    let artworkUrl60,
        artworkUrl100,
        trackName,
        primaryGenreName,
        trackContentRating,
        version,
        currentVersionReleaseDate,
        description,
        sellerName,
        fileSizeBytes: String
    let releaseNotes,
        sellerUrl: String?
    let userRatingCount: Int
    let averageUserRating: Double
    let genres,
        languageCodesISO2A: [String]
}
