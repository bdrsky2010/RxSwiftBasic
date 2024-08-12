//
//  iTunesSearchCellViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/10/24.
//

import Foundation

import RxSwift

final class iTunesSearchCellViewModel: BaseViewModel {
    struct Input {
        let disposeBag: DisposeBag
        let downloadButtonTap: Observable<String>
    }
    
    struct Output {
        let openUrl: Observable<URL?>
    }
    
    func transform(input: Input) -> Output {
        let openUrl = input.downloadButtonTap
            .map { URL(string: $0) }
        return Output(openUrl: openUrl)
    }
}
