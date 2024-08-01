//
//  PasswordViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/1/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class PasswordViewController: UIViewController {
    private let passwordTextField = BorderTextField(placeholderText: "비밀번호를 입력해주세요")
    private let validLabel = UILabel()
    private let nextButton = FilledButton(title: "다음")
    
    private let disposeBag = DisposeBag()
    
    /*
     1. 비밀번호 텍스트필드가 8자리 이상일 때 true
     2. true일 때 버튼 활성화
     3. 다음 버튼 탭 시 화면 전환
     4. descriptionLabel 임시로 추가 ("8자 이상 입력해주세요")
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let validPassword = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        validPassword
            .bind(with: self) { owner, isValid in
                owner.nextButton.backgroundColor = isValid ? .systemBlue : .gray
                owner.nextButton.isEnabled = isValid
                owner.validLabel.isHidden = isValid
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withLatestFrom(passwordTextField.rx.text.orEmpty)
            .bind(with: self) { owner, number in
                owner.view.makeToast("\(number) 입력됨", duration: 1.5)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(passwordTextField)
        view.addSubview(validLabel)
        view.addSubview(nextButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(validLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        validLabel.text = ""
        validLabel.textColor = .systemRed
    }
}
