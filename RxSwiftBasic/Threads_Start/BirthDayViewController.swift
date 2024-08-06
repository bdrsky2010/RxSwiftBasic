//
//  BirthDayViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BirthDayViewController: UIViewController {
    private let titleLabel = UILabel()
    
    private let birthDayPickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    private let validLabel = UILabel()
    
    private let nextButton = FilledButton(title: "가입완료")
    
    
    private let viewModel = BirthDayViewModel()
    private let disposeBag = DisposeBag()
    
    private let validText = "가입 가능한 나이입니다"
    private let invalidText = "만 17세 이상만 가입 가능합니다."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let input = BirthDayViewModel.Input(birthDayDate: birthDayPickerView.rx.date,
                                            nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validAge
            .bind(with: self) { owner, isValid in
                owner.validLabel.text = isValid ? owner.validText : owner.invalidText
                owner.validLabel.textColor = isValid ? .systemBlue : .systemRed
                
                owner.nextButton.isEnabled = isValid
                owner.nextButton.backgroundColor = isValid ? .systemBlue : .systemGray
            }
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.changeRootViewController(LoginViewController())
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(birthDayPickerView)
        view.addSubview(validLabel)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(birthDayPickerView.snp.top).offset(-20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        birthDayPickerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(birthDayPickerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        titleLabel.text = "생년월일"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        validLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
