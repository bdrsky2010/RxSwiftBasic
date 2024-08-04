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
    
    private let year = BehaviorRelay(value: 0)
    private let month = BehaviorRelay(value: 0)
    private let day = BehaviorRelay(value: 0)
    private let disposeBag = DisposeBag()
    
    private let validText = "가입 가능한 나이입니다"
    private let invalidText = "만 17세 이상만 가입 가능합니다."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        birthDayPickerView.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                if let year = component.year, let month = component.month, let day = component.day {
                    owner.year.accept(year)
                    owner.month.accept(month)
                    owner.day.accept(day)
                }
            }
            .disposed(by: disposeBag)
        
        let validAge = Observable.combineLatest(year, month, day)
            .map { year, month, day in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                guard let todayYear = component.year,
                      let todayMonth = component.month,
                      let todayDay = component.day
                else { return false }
                
                if todayYear - year > 17 {
                    return true
                }
                
                if todayYear - year == 17 {
                    if todayMonth > month {
                        return true
                    }
                    
                    if todayMonth == month, todayDay >= day {
                        return true
                    }
                }
                
                return false
            }
        
        validAge
            .bind(with: self) { owner, isValid in
                owner.validLabel.text = isValid ? owner.validText : owner.invalidText
                owner.validLabel.textColor = isValid ? .systemBlue : .systemRed
                
                owner.nextButton.isEnabled = isValid
                owner.nextButton.backgroundColor = isValid ? .systemBlue : .systemGray
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
