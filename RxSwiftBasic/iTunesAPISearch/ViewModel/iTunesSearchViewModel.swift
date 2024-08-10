//
//  iTunesSearchViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import RxSwift

final class iTunesSearchViewModel {
    struct Input {
        let cancelButtonTap: PublishSubject<Void>
        let searchTextChange: PublishSubject<String>
        let searchButtonTap: PublishSubject<String>
    }
    
    struct Output {
        let requestResult: PublishSubject<[SearchApp]>
    }
    
    private let searchResult = PublishSubject<[SearchApp]>()
    private let disposeBag = DisposeBag()
    
    private let firstLimit = 10
    private let nextLimit = 20
    
    private var requestQuery = ""
    private var requestLimit = 10
    private var isLastRequest = false
    
    func transform(input: Input) -> Output {
        input.cancelButtonTap
            .subscribe(with: self) { owner, _ in
                owner.searchResult.onNext([])
            }
            .disposed(by: disposeBag)
        
        input.searchTextChange
            .subscribe(with: self) { owner, text in
                print("검색 텍스트 변경: \(text)")
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .distinctUntilChanged()
            .subscribe(with: self) { owner, query in
                owner.requestQuery = query
                owner.requestLimit = owner.firstLimit
                
                let url = owner.getiTunesAPIUrl(query: owner.requestQuery, limit: owner.requestLimit)
                NetworkManager.shared.requestAPIWithSingle(url: url, of: iTunesSearch.self)
                    .subscribe(with: self) { owner, value in
                        dump(value)
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(requestResult: searchResult)
    }
    
    private func getiTunesAPIUrl(query: String, limit: Int) -> String {
        let urlString = "https://itunes.apple.com/search?term=\(query)&entity=software&country=kr&lang=ko_kr&limit=\(limit)"
        return urlString
    }
}
