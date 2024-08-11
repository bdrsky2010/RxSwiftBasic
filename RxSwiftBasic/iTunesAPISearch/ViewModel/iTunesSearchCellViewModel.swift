//
//  iTunesSearchCellViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/10/24.
//

import UIKit

import RxSwift

final class iTunesSearchCellViewModel {
    struct Input {
        let disposeBag: DisposeBag
        let downloadButtonTap: Observable<String>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) {
        input.downloadButtonTap
            .subscribe(with: self) { owner, urlString in
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: input.disposeBag)
    }
}
