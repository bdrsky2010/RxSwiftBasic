//
//  iTunesSearchViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import SnapKit

final class iTunesSearchViewController: UIViewController {
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.searchController = searchController
    }
}
