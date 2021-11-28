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

// MARK: - Result
struct AppStoreApp: Codable {
    let screenshotUrls: [String]
    let artworkUrl60,
        trackName,
        primaryGenreName: String
    let userRatingCount: Int
    let averageUserRating: Double
//    let artistViewURL: String
//    let isGameCenterEnabled: Bool
//    let features, supportedDevices, advisories: [String]
//    let kind, minimumOSVersion, trackCensoredName: String
//    let languageCodesISO2A: [String]
//    let fileSizeBytes, formattedPrice, contentAdvisoryRating: String
//    let averageUserRatingForCurrentVersion: Double
//    let userRatingCountForCurrentVersion: Int
//    let averageUserRating: Double
//    let trackViewURL: String
//    let trackContentRating, bundleID: String
//    let releaseDate: Date
//    let trackID: Int
    
//    let sellerName, primaryGenreName: String
//    let genreIDS: [String]
//    let isVppDeviceBasedLicensingEnabled: Bool
//    let currentVersionReleaseDate: Date
//    let releaseNotes: String
//    let primaryGenreID: Int
//    let currency, version, wrapperType, resultDescription: String
//    let artistID: Int
//    let artistName: String
//    let genres: [String]
//    let price, userRatingCount: Int
//    let sellerURL: String?
}
