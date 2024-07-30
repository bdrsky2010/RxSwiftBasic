//
//  ViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 7/30/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

enum CellItem: CaseIterable {
    case numbers
    case validation
    case tableView
    case pickerView
    
    var title: String { String(describing: self) }
    
    var viewController: UIViewController {
        switch self {
        case .numbers: NumbersViewController()
        case .validation: SimpleValidationViewController()
        case .tableView: SimpleTableViewController()
        case .pickerView: SimplePickerExampleViewController()
        }
    }
}

final class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let disposeBag = DisposeBag()
    private let cellItems = Observable.just(CellItem.allCases)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "RxSwift Basic"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCell")
        cellItems
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SystemCell") else { return UITableViewCell() }
                cell.textLabel?.text = element.title
                return cell
            }
            .disposed(by: disposeBag)
            
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(CellItem.self))
            .subscribe(with: self) { owner, tuple in
                owner.tableView.reloadRows(at: [tuple.0], with: .automatic)
                owner.navigationController?.pushViewController(tuple.1.viewController, animated: true)
            }
            .disposed(by: disposeBag)

    }
}

