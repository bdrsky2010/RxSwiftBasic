//
//  SimpleValidationViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 7/30/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class SimpleValidationViewController: UIViewController {
    private let usernameTitleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let usernameValidLabel = UILabel()
    private let passwordTitleLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordValidLabel = UILabel()
    private let signupButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = CellItem.validation.title
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        view.addSubview(usernameTitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameValidLabel)
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidLabel)
        view.addSubview(signupButton)
    }
    
    private func configureLayout() {
        usernameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        usernameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValidLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
    }
    
    private func configureUI() {
        let labelFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        usernameTitleLabel.text = "Username"
        usernameTitleLabel.font = labelFont
        usernameTextField.borderStyle = .roundedRect
        usernameValidLabel.font = labelFont
        passwordTitleLabel.text = "Password"
        passwordTitleLabel.font = labelFont
        passwordTextField.borderStyle = .roundedRect
        passwordValidLabel.font = labelFont
        signupButton.configuration = .borderedProminent()
        signupButton.configuration?.title = "회원가입"
    }
    
    private func bindData() {
        let minimalUsernameLength = 5
        let minimalPasswordLength = 5
        
        let isUsernameValid = usernameTextField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        let isPasswordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        let isEverythingValid = Observable.combineLatest(isUsernameValid, isPasswordValid) { $0 && $1 }
            .share(replay: 1)
        
        isUsernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        isUsernameValid
            .bind(with: self) { owner, isValid in
                owner.usernameValidLabel.text = isValid ? "Pass" : "Username has to be at least \(minimalUsernameLength) characters"
                owner.usernameValidLabel.textColor = isValid ? .systemBlue : .systemRed
            }
            .disposed(by: disposeBag)
        isPasswordValid
            .bind(with: self) { owner, isValid in
                owner.passwordValidLabel.text = isValid ? "Pass" : "Username has to be at least \(minimalUsernameLength) characters"
                owner.passwordValidLabel.textColor = isValid ? .systemBlue : .systemRed
            }
            .disposed(by: disposeBag)
        isEverythingValid
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        signupButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.makeToast("회원가입 완료")
            }
            .disposed(by: disposeBag)
    }
}
