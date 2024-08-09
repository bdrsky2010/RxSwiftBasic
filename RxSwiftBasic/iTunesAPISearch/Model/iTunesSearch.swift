//
//  iTunesSearch.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/9/24.
//

import Foundation

struct iTunesSearch: Decodable {
    let resultCount: Int
    var results: [SearchApp]
}

struct SearchApp: Decodable {
    let screenshotUrls: [String] // 앱 스토어 iOS앱 스크린샷
    let ipadScreenshotUrls: [String] // 앱 스토어 iPadOS 앱 스크린샷
    
    let artworkUrl60: String // 60 x 60 사이즈 앱 아이콘 이미지
    let artworkUrl512: String // 512 x 512 사이즈 앱 아이콘 이미지
    let artworkUrl100: String // 100 x 100 사이즈 앱 아이콘 이미지
    
    let artistViewUrl: String // 개발자 상세 화면
    let fileSizeBytes: String // 파일 용량
    let sellerUrl: String // 앱 공식 홈페이지
    let contentAdvisoryRating: String // 연령
    let userRatingCountForCurrentVersion: Int // 사용자 평가 수
    let trackViewUrl: String // 앱 스토어 상세 페이지 링크
    let averageUserRatingForCurrentVersion: Double // 최신 버전 유저 평균 평가 점수
    let averageUserRating: Double // 유저 평균 평가 점수
    let languageCodesISO2A: [String] // 사용 가능 언어 리스트 (한국 언어 코드는 "KO")
    let currentVersionReleaseDate: String // 최신 버전 배포 날짜
    let description: String // 상세정보
    let trackId: Int // 앱 ID
    let trackName: String // 앱 이름
    let sellerName: String // 앱 회사 이름
    let releaseNotes: String // 업데이트 노트
    let minimumOsVersion: String // OS 최소 버전
    let genres: [String] // 앱 장르
}
