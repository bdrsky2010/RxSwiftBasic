//
//  LoginViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class LoginViewController: UIViewController {
    private let emailTitleLabel = UILabel()
    private let emailTextField = BorderTextField(placeholderText: "이메일을 입력해주세요")
    private let passwordTitleLabel = UILabel()
    private let passwordTextField = BorderTextField(placeholderText: "비밀번호를 입력해주세요")
    private let loginButton = FilledButton(title: "로그인")
    private let signupButton = UnderlineButton(title: "회원가입")
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.makeToast("로그인 완료", duration: 1.5)
            }
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(EmailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(emailTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTitleLabel.text = "이메일"
        passwordTitleLabel.text = "비밀번호"
        loginButton.backgroundColor = .systemBlue
    }
}
