//
//  iTunesSearchViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import RxSwift

final class iTunesSearchViewModel: BaseViewModel {
    struct Input {
        let cancelButtonTap: PublishSubject<Void>
        let searchTextChange: PublishSubject<String>
        let searchButtonTap: PublishSubject<String>
        let cellSelect: PublishSubject<SearchApp>
    }
    
    struct Output {
        let requestResult: PublishSubject<[SectioniTunesSearch]>
        let requestError: PublishSubject<String>
        let SearchDetailPush: PublishSubject<SearchApp>
    }
    
    private let searchResult = PublishSubject<[SectioniTunesSearch]>()
    private let searchError = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private let firstLimit = 10
    private let nextLimit = 20
    
    private var requestQuery = ""
    private var requestLimit = 10
    private var isLastRequest = false
    
    func transform(input: Input) -> Output {
        input.cancelButtonTap
            .subscribe(with: self) { owner, _ in
                print("취소버튼 탭")
                owner.requestQuery = ""
                owner.searchResult.onNext([])
            }
            .disposed(by: disposeBag)
        
        input.searchTextChange
            .subscribe(with: self) { owner, text in
                owner.requestQuery = ""
                owner.searchResult.onNext([])
                print("검색 텍스트 변경: \(text)")
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .subscribe(with: self) { owner, query in
                if owner.requestQuery != query {
                    owner.requestQuery = query
                    owner.requestLimit = owner.firstLimit
                    
                    let url = owner.getiTunesAPIUrl(query: owner.requestQuery, limit: owner.requestLimit)
                    NetworkManager.shared.requestAPIWithSingle(url: url, of: iTunesSearch.self)
                        .asDriver(onErrorJustReturn: .failure(.unknown))
                        .debug("driver")
                        .drive(with: self) { owner, result in
                            switch result {
                            case .success(let value):
                                print("result count: \(value.resultCount)")
                                owner.searchResult.onNext([SectioniTunesSearch(items: value.results)])
                            case .failure(let error):
                                print(error.message)
                                owner.searchError.onNext(error.message)
                            }
                        } onCompleted: { _ in
                            print("requestAPI completed")
                        } onDisposed: { _ in
                            print("requestAPI disposed")
                        }
                        .disposed(by: owner.disposeBag)
                }
            } onCompleted: { _ in
                print("searchButtonTap completed")
            } onDisposed: { _ in
                print("searchButtonTap diposed")
            }
            .disposed(by: disposeBag)
        
        return Output(requestResult: searchResult,
                      requestError: searchError,
                      SearchDetailPush: input.cellSelect)
    }
    
    private func getiTunesAPIUrl(query: String, limit: Int) -> String {
        let urlString = "https://itunes.apple.com/search?term=\(query)&entity=software&country=kr&lang=ko_kr&limit=\(limit)"
//        let urlString = "https://itunes.apple.com/search?term=&entity=software&country=kr&lang=ko_kr&limit=\(limit)"
        return urlString
    }
}
