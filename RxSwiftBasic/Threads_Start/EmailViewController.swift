//
//  EmailViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class EmailViewController: UIViewController {
    private let titleLabel = UILabel()
    private let idTextField = BorderTextField(placeholderText: "")
    private let atSighLabel = UILabel()
    private let domainTextField = BorderTextField(placeholderText: "")
    private let nextButton = FilledButton(title: "다음")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let idValid = idTextField.rx.text.orEmpty
            .map { $0.count > 0 }
        
        let domainValid = domainTextField.rx.text.orEmpty
            .map { $0.count > 0 }
        
        let emailValid = Observable.combineLatest(idValid, domainValid) { $0 && $1 }
        
        emailValid
            .bind(with: self) { owner, isValid in
                owner.nextButton.isEnabled = isValid
                owner.nextButton.backgroundColor = isValid ? .systemBlue : .systemGray
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(atSighLabel)
        view.addSubview(domainTextField)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(domainTextField.snp.width)
            make.height.equalTo(50)
        }
        
        atSighLabel.snp.makeConstraints { make in
            make.centerY.equalTo(idTextField.snp.centerY)
            make.leading.equalTo(idTextField.snp.trailing).offset(4)
        }
        
        domainTextField.snp.makeConstraints { make in
            make.bottom.equalTo(idTextField.snp.bottom)
            make.leading.equalTo(atSighLabel.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(idTextField.snp.width)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(domainTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        titleLabel.text = "이메일"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        atSighLabel.text = "@"
        atSighLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
