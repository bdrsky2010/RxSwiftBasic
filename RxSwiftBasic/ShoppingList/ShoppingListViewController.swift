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
    private let shoppingTableView = UITableView()
    
    private let viewModel = ShoppingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let addTap = addTextField.addButton.rx
            .tap
            .withLatestFrom(addTextField.textField.rx.text.orEmpty)
        
        let viewInput = ShoppingListViewModel.Input(addTap: addTap)
        var viewOutput = viewModel.transform(input: viewInput)
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionShopping>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell
                else { return UITableViewCell() }
                
                cell.completeButton.configuration?.image = (item.isComplete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square"))?
                    .withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
                cell.titleLabel.text = item.title
                cell.starButton.configuration?.image = (item.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))?
                    .withTintColor(.systemYellow, renderingMode: .alwaysTemplate)
                cell.indexPath.accept(indexPath)
                
                let completeTap = cell.completeButton.rx
                    .tap
                    .withLatestFrom(cell.indexPath)
                
                let starTap = cell.starButton.rx
                    .tap
                    .withLatestFrom(cell.indexPath)
                
                let cellInput = ShoppingListViewModel.CellInput(completeTap: completeTap, starTap: starTap, disposeBag: cell.disposeBag)
                let output = viewModel.transform(input: cellInput)
                viewOutput.reload = output.reload
                return cell
            })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewOutput.reload
            .bind(to: shoppingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        navigationItem.title = "쇼핑"
        
        view.backgroundColor = .white
        
        view.addSubview(addTextField)
        view.addSubview(shoppingTableView)
        
        addTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        
        shoppingTableView.snp.makeConstraints { make in
            make.top.equalTo(addTextField.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        shoppingTableView.rowHeight = 50
        shoppingTableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
    }
}
