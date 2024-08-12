//
//  iTunesSearchDetailViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import Foundation

import RxSwift

final class iTuneSearchDetailViewModel: BaseViewModel {
    private let screenshotUrlList = PublishSubject<[SectioniDetailScreenshot]>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let initVC: PublishSubject<SearchApp>
        let downloadButtonTap: Observable<String>
        let companyLabelTap: Observable<String>
    }
    
    struct Output {
        let configureContent: PublishSubject<SearchApp>
        let screenshotUrlList: PublishSubject<[SectioniDetailScreenshot]>
        let openDownloadUrl: Observable<URL?>
        let openCompanyUrl: Observable<URL?>
    }
    
    func transform(input: Input) -> Output {
        let screenshotUrlList = PublishSubject<[SectioniDetailScreenshot]>()
        
        input.initVC
            .map {
                [SectioniDetailScreenshot(items: $0.screenshotUrls)]
            }
            .subscribe(screenshotUrlList)
            .disposed(by: disposeBag)
        
        let openDownloadUrl = input.downloadButtonTap
            .map { URL(string: $0) }
        
        let openCompanyUrl = input.companyLabelTap
            .map { URL(string: $0) }
        
        return Output(configureContent: input.initVC,
                      screenshotUrlList: screenshotUrlList,
                      openDownloadUrl: openDownloadUrl,
                      openCompanyUrl: openCompanyUrl)
    }
}
