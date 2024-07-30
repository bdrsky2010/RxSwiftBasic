//
//  NumbersViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 7/30/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class NumbersViewController: UIViewController {
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let plus = UILabel()
    private let separator = UIView()
    private let result = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = CellItem.numbers.title
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(plus)
        view.addSubview(separator)
        view.addSubview(result)
    }
    
    private func configureLayout() {
        number1.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(30)
            make.centerX.equalTo(number2.snp.centerX)
            make.bottom.equalTo(number2.snp.top).offset(-8)
        }
        
        number2.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(8)
            make.width.equalTo(97)
            make.height.equalTo(30)
            make.centerX.equalTo(number2.snp.centerX)
        }
        
        plus.snp.makeConstraints { make in
            make.centerY.equalTo(number3.snp.centerY)
            make.trailing.equalTo(number3.snp.leading).offset(-8)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(8)
            make.leading.equalTo(plus.snp.leading)
            make.trailing.equalTo(number3.snp.trailing)
            make.height.equalTo(1)
        }
        
        result.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.leading.trailing.equalTo(separator)
        }
    }
    
    private func configureUI() {
        number1.borderStyle = .roundedRect
        number1.text = "1"
        number1.textAlignment = .right
        number2.borderStyle = .roundedRect
        number2.text = "2"
        number2.textAlignment = .right
        number3.borderStyle = .roundedRect
        number3.text = "3"
        number3.textAlignment = .right
        separator.backgroundColor = .black
        plus.text = "+"
        plus.font = .systemFont(ofSize: 17)
        result.text = "6"
        result.font = .systemFont(ofSize: 17)
        result.textAlignment = .right
    }
    
    private func bindData() {
        Observable
            .combineLatest(
                number1.rx.text.orEmpty,
                number2.rx.text.orEmpty,
                number3.rx.text.orEmpty
            ) { value1, value2, value3 -> Int in
                return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
            }
            .map { String($0) }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
}
