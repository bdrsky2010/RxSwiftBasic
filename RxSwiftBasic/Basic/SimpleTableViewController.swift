//
//  SimpleTableViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 7/30/24.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import SnapKit
import Toast

final class SimpleTableViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let disposeBag = DisposeBag()
    
    private let list = BehaviorSubject(value: [Market]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = CellItem.tableView.title
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCell")
        
        list
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SystemCell") else { return UITableViewCell() }
                cell.textLabel?.text = element.title
                return cell
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Market.self))
            .subscribe(with: self) { owner, tuple in
                owner.tableView.reloadRows(at: [tuple.0], with: .automatic)
                owner.view.makeToast(tuple.1.market, duration: 1.5)
            }
            .disposed(by: disposeBag)
        
        let url = "https://api.upbit.com/v1/market/all"
        
        AF.request(url).responseDecodable(of: [Market].self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let success):
                list.onNext(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
