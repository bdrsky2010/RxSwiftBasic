//
//  iTunesSearchDetailViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import Foundation

import RxSwift

final class iTuneSearchDetailViewModel {
    private let screenshotUrlList = PublishSubject<[SectioniDetailScreenshot]>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let initVC: PublishSubject<SearchApp>
    }
    
    struct Output {
        let configureContent: PublishSubject<SearchApp>
        let screenshotUrlList: PublishSubject<[SectioniDetailScreenshot]>
    }
    
    func transform(input: Input) -> Output {
        let screenshotUrlList = PublishSubject<[SectioniDetailScreenshot]>()
        
        input.initVC
            .map {
                [SectioniDetailScreenshot(items: $0.screenshotUrls)]
            }
            .subscribe(screenshotUrlList)
            .disposed(by: disposeBag)
        
        return Output(configureContent: input.initVC, screenshotUrlList: screenshotUrlList)
    }
}
