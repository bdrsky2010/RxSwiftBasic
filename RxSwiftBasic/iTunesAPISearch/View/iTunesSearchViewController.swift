//
//  iTunesSearchViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class iTunesSearchViewController: UIViewController {
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        return searchController
    }()
    
    private let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let viewModel = iTunesSearchViewModel()
    private let cellViewModel = iTunesSearchCellViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        configureView()
        bind()
    }
    
    private func bind() {
        let cancelButtonTap = PublishSubject<Void>()
        let searchTextChange = PublishSubject<String>()
        let searchButtonTap = PublishSubject<String>()
        let cellSelect = PublishSubject<SearchApp>()
        
        searchController.searchBar.rx.cancelButtonClicked
            .bind(to: cancelButtonTap)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .bind(to: searchTextChange)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .bind(to: searchButtonTap)
            .disposed(by: disposeBag)
        
        resultCollectionView.rx.modelSelected(SearchApp.self)
            .bind(to: cellSelect)
            .disposed(by: disposeBag)
        
        let input = iTunesSearchViewModel.Input(cancelButtonTap: cancelButtonTap,
                                                searchTextChange: searchTextChange,
                                                searchButtonTap: searchButtonTap,
                                                cellSelect: cellSelect)
        
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectioniTunesSearch> { [weak self] dataSource, collectionView, indexPath, item in
            guard let self, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iTunesSearchCollectionViewCell.identifier, for: indexPath) as? iTunesSearchCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureContent(searchApp: item)
            
            let trackViewUrl = Observable.just(item.trackViewUrl)
            let downloadButtonTap = cell.downloadButton.rx.tap
                .withLatestFrom(trackViewUrl)
            let input = iTunesSearchCellViewModel.Input(disposeBag: cell.disposeBag, downloadButtonTap: downloadButtonTap)
            cellViewModel.transform(input: input)
            return cell
        }
        
        output.requestResult
            .bind(to: resultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.SearchDetailPush
            .bind(with: self) { owner, searchApp in
                print("눌림")
                owner.navigationController?.pushViewController(iTunesSearchDetailViewController(searchApp: searchApp), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.addSubview(resultCollectionView)
        
        resultCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        resultCollectionView.register(iTunesSearchCollectionViewCell.self,
                                      forCellWithReuseIdentifier: iTunesSearchCollectionViewCell.identifier)
    }
}

extension iTunesSearchViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 30, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
