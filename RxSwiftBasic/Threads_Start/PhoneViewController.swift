//
//  PhoneViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PhoneViewController: UIViewController {
    private let titleLabel = UILabel()
    private let firstNumberTextField = BorderTextField(placeholderText: "")
    private let firstDashLabel = UILabel()
    private let secondNumberTextField = BorderTextField(placeholderText: "")
    private let secondDashLabel = UILabel()
    private let thirdNumberTextField = BorderTextField(placeholderText: "")
    private let nextButton = FilledButton(title: "다음")
    
    
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let firstNumber = firstNumberTextField.rx.text
        let secondNumber = secondNumberTextField.rx.text
        let thirdNumber = thirdNumberTextField.rx.text
        let input = PhoneViewModel.Input(first: firstNumber,
                                         second: secondNumber,
                                         third: thirdNumber,
                                         nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.firstNumber
            .bind(to: firstNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.validFirst
            .bind(with: self) { owner, isValid in
                owner.firstNumberTextField.layer.borderColor = isValid ? UIColor.systemBlue.cgColor : UIColor.systemRed.cgColor
            }
            .disposed(by: disposeBag)
            
        output.validSecond
            .bind(with: self) { owner, isValid in
                owner.secondNumberTextField.layer.borderColor = isValid ? UIColor.systemBlue.cgColor : UIColor.systemRed.cgColor
            }
            .disposed(by: disposeBag)
        
        output.validThird
            .bind(with: self) { owner, isValid in
                owner.thirdNumberTextField.layer.borderColor = isValid ? UIColor.systemBlue.cgColor : UIColor.systemRed.cgColor
            }
            .disposed(by: disposeBag)
        
        output.validTotal
            .bind(with: self) { owner, isValid in
            owner.nextButton.isEnabled = isValid
            owner.nextButton.backgroundColor = isValid ? .systemBlue : .systemGray
        }
        .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthDayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(firstNumberTextField)
        view.addSubview(firstDashLabel)
        view.addSubview(secondNumberTextField)
        view.addSubview(secondDashLabel)
        view.addSubview(thirdNumberTextField)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        firstNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(secondNumberTextField.snp.width)
            make.height.equalTo(50)
        }
        
        firstDashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstNumberTextField.snp.centerY)
            make.leading.equalTo(firstNumberTextField.snp.trailing).offset(4)
        }
        
        secondNumberTextField.snp.makeConstraints { make in
            make.bottom.equalTo(firstNumberTextField.snp.bottom)
            make.leading.equalTo(firstDashLabel.snp.trailing).offset(4)
            make.width.equalTo(thirdNumberTextField.snp.width)
            make.height.equalTo(50)
        }
        
        secondDashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(secondNumberTextField.snp.centerY)
            make.leading.equalTo(secondNumberTextField.snp.trailing).offset(4)
        }
        
        thirdNumberTextField.snp.makeConstraints { make in
            make.centerY.equalTo(secondDashLabel.snp.centerY)
            make.leading.equalTo(secondDashLabel.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(secondNumberTextField.snp.width)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(firstNumberTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        titleLabel.text = "전화번호"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        firstDashLabel.text = "-"
        firstDashLabel.font = .systemFont(ofSize: 20, weight: .bold)
        secondDashLabel.text = "-"
        secondDashLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
