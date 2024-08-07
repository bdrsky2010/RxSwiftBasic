//
//  ShoppingListViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class ShoppingListViewController: UIViewController {
    private let addTextField = AddTextField(placeholder: "무엇을 구매하실 건가요?")
    private let recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let shoppingTableView = UITableView()
    
    private let viewModel = ShoppingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension ShoppingListViewController {
    private func bind() {
        let addTap = addTextField.addButton.rx
            .tap
            .withLatestFrom(addTextField.textField.rx.text.orEmpty)
        
        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<SectionRecommend> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell 
            else { return UICollectionViewCell() }
            
            cell.configureLabelText(text: item.title)
            
            return cell
        }
        
        let recommend = Observable.just(RecommendData.sections)
        recommend
            .bind(to: recommendCollectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: disposeBag)
        
        let recommendTap = recommendCollectionView.rx.modelSelected(Recommend.self)
        
        let delete = shoppingTableView.rx.itemDeleted
        let viewInput = ShoppingListViewModel.Input(addTap: addTap, recommendTap: recommendTap, delete: delete)
        var viewOutput = viewModel.transform(input: viewInput)
        
        let tableViewDataSource = RxTableViewSectionedAnimatedDataSource<SectionShopping>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell
                else { return UITableViewCell() }
                
                cell.completeButton.configuration?.image = (item.isComplete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square"))?
                    .withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
                cell.titleLabel.text = item.title
                cell.starButton.configuration?.image = (item.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))?
                    .withTintColor(.systemYellow, renderingMode: .alwaysTemplate)
                
                let id = Observable.just(item.id)
                
                let completeTap = cell.completeButton.rx
                    .tap
                    .withLatestFrom(id)
                
                let starTap = cell.starButton.rx
                    .tap
                    .withLatestFrom(id)
                
                let cellInput = ShoppingListViewModel.CellInput(completeTap: completeTap, starTap: starTap, disposeBag: cell.disposeBag)
                let output = viewModel.transform(input: cellInput)
                viewOutput.reload = output.reload
                return cell
            })
        
        tableViewDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        tableViewDataSource.canEditRowAtIndexPath = { dataSource, index in
            return true
        }
        
        viewOutput.reload
            .bind(to: shoppingTableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
    }
}

extension ShoppingListViewController {
    private func configureView() {
        navigationItem.title = "쇼핑"
        
        view.backgroundColor = .white
        
        view.addSubview(addTextField)
        view.addSubview(recommendCollectionView)
        view.addSubview(shoppingTableView)
        
        addTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        shoppingTableView.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        recommendCollectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        
        shoppingTableView.allowsSelection = false
        shoppingTableView.rowHeight = 50
        shoppingTableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
    }
}

extension ShoppingListViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(40),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
