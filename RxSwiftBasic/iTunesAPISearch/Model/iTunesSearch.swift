//
//  iTunesSearch.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/9/24.
//

import Foundation

import Differentiator

struct SectioniTunesSearch {
    var items: [Item]
}

extension SectioniTunesSearch: SectionModelType {
    typealias Item = SearchApp
    
    init(original: SectioniTunesSearch, items: [SearchApp]) {
        self = original
        self.items = items
    }
}

struct iTunesSearch: Decodable {
    let resultCount: Int
    var results: [SearchApp]
}

struct SearchApp: Decodable, Hashable, Identifiable {
    let id: Int // 앱 ID
    let screenshotUrls: [String] // 앱 스토어 iOS앱 스크린샷
    let ipadScreenshotUrls: [String] // 앱 스토어 iPadOS 앱 스크린샷
    let artworkUrl60: String // 60 x 60 사이즈 앱 아이콘 이미지
    let artworkUrl512: String // 512 x 512 사이즈 앱 아이콘 이미지
    let artworkUrl100: String // 100 x 100 사이즈 앱 아이콘 이미지
    let artistViewUrl: String // 개발자 상세 화면
    let fileSizeBytes: String // 파일 용량
    let sellerUrl: String? // 앱 공식 홈페이지
    let contentAdvisoryRating: String // 연령
    let userRatingCountForCurrentVersion: Int // 사용자 평가 수
    let trackViewUrl: String // 앱 스토어 상세 페이지 링크
    let trackContentRating: String
    let averageUserRatingForCurrentVersion: Double // 최신 버전 유저 평균 평가 점수
    let averageUserRating: Double // 유저 평균 평가 점수
    let languageCodesISO2A: [String] // 사용 가능 언어 리스트 (한국 언어 코드는 "KO")
    let currentVersionReleaseDate: String // 최신 버전 배포 날짜
    let description: String // 상세정보
    let trackName: String // 앱 이름
    let sellerName: String // 앱 회사 이름
    let releaseNotes: String // 업데이트 노트
    let minimumOsVersion: String // OS 최소 버전
    let genres: [String] // 앱 장르
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case screenshotUrls
        case ipadScreenshotUrls
        case artworkUrl60
        case artworkUrl512
        case artworkUrl100
        case artistViewUrl
        case fileSizeBytes
        case sellerUrl
        case contentAdvisoryRating
        case userRatingCountForCurrentVersion
        case trackViewUrl
        case trackContentRating
        case averageUserRatingForCurrentVersion
        case averageUserRating
        case languageCodesISO2A
        case currentVersionReleaseDate
        case description
        case trackName
        case sellerName
        case releaseNotes
        case minimumOsVersion
        case genres
        case version
    }
}

struct SectioniDetailScreenshot {
    var items: [Item]
}

extension SectioniDetailScreenshot: SectionModelType {
    typealias Item = String
    
    init(original: SectioniDetailScreenshot, items: [String]) {
        self = original
        self.items = items
    }
}
