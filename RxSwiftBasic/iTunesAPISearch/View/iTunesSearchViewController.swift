//
//  iTunesSearchViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class iTunesSearchViewController: UIViewController {
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        return searchController
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        let url = "https://itunes.apple.com/search?term=kakaotalk&entity=software&country=kr&lang=ko_kr&limit=10"
        NetworkManager.shared.requestAPIWithSingle(url: url, of: iTunesSearch.self)
            .subscribe(with: self) { owner, value in
                dump(value)
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
    }
}
